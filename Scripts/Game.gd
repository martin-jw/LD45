extends Node2D

export var max_npc_count: int = 10
export var max_trash_count: int = 10
export var trash_spawn_interval: float = 1.0

export var max_special_tries: int = 2000
export var max_npc_special: int = 250

onready var city = $City
onready var chatbox = $"UILayer/ChatBox"
onready var ui_inventory = $"UILayer/UiInventory"
var camera: Camera
var player

const Player = preload("res://Scenes/Player.tscn")
const Npc = preload("res://Scenes/NPC.tscn")
const NpcSpecial = preload("res://Scenes/NpcSpecial.tscn")
const Trash = preload("res://Scenes/Trash.tscn")

var npc_count: int = 0
var special_npc_count: int = 0
var special_spawned: bool = false

var trash_timer: float = trash_spawn_interval
var trash_count: int = 0

var converser = null
var conversation_stage = 0
var converse_tick = 2

var trader = null
var item_to_trade = null
var num_to_trade = 0
var items_required = null
var can_trade: bool = false

func _ready():
	
	camera = $Camera
	
	player = Player.instance()
	player.position = city.get_spawnpoint()
	call_deferred("add_child", player)
	
	player.connect("inventory_item_changed", ui_inventory, "update_item")
	
	var remote_transform = RemoteTransform2D.new()
	remote_transform.remote_path = camera.get_path()
	player.add_child(remote_transform)
	
	propagate_call("_game_ready", [self])

func spawn_trash():
	
	for i in range(0, 5):
		var x = rand_range(-1280, 1280)
		var y = rand_range(-720, 720) * ((randi() % 2) * 2 - 1)
	
		if x > -670 and x < 670 and y > -390 and y < 390:
			continue
		
		var pos = camera.position - Vector2(0, 128) + Vector2(x, y)
		if city.get_closest_point(pos) == pos:
			var trash = Trash.instance()
			trash.connect("removed", self, "_on_trash_removed")
			trash.position = pos
			call_deferred("add_child", trash)
			trash_count += 1

func spawn_special():
	
	var i = 0
	while i < max_special_tries and special_npc_count < max_npc_special:
		var x = rand_range(0, (city.size.x + 1) * 128)
		var y = rand_range(0, (city.size.y + 1) * 128)
		
		var pos = Vector2(x, y)
	
		if city.get_closest_point(pos) == pos:
			var npc = NpcSpecial.instance()
			
			npc.set_script(Specials.get_random_script())

			npc.connect("conversation_started", self, "start_conversation")
			npc.position = pos
			call_deferred("add_child", npc)
			special_npc_count += 1
		
		i += 1
	print("Spawned ", special_npc_count, " specials!")

func spawn_npc():
	
	var x = rand_range(-1280, 1280)
	var y = rand_range(-720, 720) * ((randi() % 2) * 2 - 1)

	if x > -672 and x < 672 and y > -360 and y < 616:
		return

	var pos = camera.position - Vector2(0, 128) + Vector2(x, y)
	
	if city.get_closest_point(pos) == pos:
		var npc = Npc.instance()
		npc.connect("trade_started", self, "begin_trade")
		npc_count += 1
		npc.position = pos
		call_deferred("add_child", npc)

func _process(delta):
	trash_timer += delta
	
	if !special_spawned:
		spawn_special()
		special_spawned = true
	
	if trash_timer >= trash_spawn_interval and trash_count < max_trash_count:
		spawn_trash()
		trash_timer = 0
	
	if npc_count < max_npc_count:
		if randf() < 0.3:
			spawn_npc()
			
	if trader != null:
		if can_trade and Input.is_action_just_pressed("interact"):
			for k in items_required:
				player.inventory.remove(k, items_required[k])
			player.inventory.add(item_to_trade, num_to_trade)
			player.trading = false
			trader.trading = false
			trader.traded = true
			chatbox.visible = false
			trader = null
		elif Input.is_action_just_pressed("cancel"):
			player.trading = false
			trader.trading = false
			chatbox.visible = false
			trader = null

	if converser != null:
		if Input.is_action_just_pressed("interact"):
			converser.response(player, conversation_stage, true)
		elif Input.is_action_just_pressed("cancel"):
			converser.response(player, conversation_stage, false)
	
	if converse_tick < 2:
		converse_tick += 1
		if converse_tick == 2:
			self.converser.trading = false
			player.trading = false
			self.converser = null

func check_trade_possible():
	if trader == null:
		return false
	
	for k in items_required:
		if player.inventory.get_count(k) < items_required[k]:
			return false
	
	return true

func start_conversation(converser, text):
	self.converser = converser
	self.converser.connect("respond", self, "conversation_response")
	chatbox.set_text(text)
	chatbox.set_visible(true)
	self.conversation_stage = 0


func conversation_response(text):
	if self.converser != null:
		if text == "END":
			self.converser.disconnect("respond", self, "conversation_response")
			converse_tick = 0
			chatbox.set_visible(false)
		else:
			chatbox.set_text(text)
			conversation_stage += 1

func begin_trade(trader: Node2D, prompt: Array, item_to_trade: String, num_to_trade: int, items_required: Dictionary):

	self.trader = trader
	self.item_to_trade = item_to_trade
	self.num_to_trade = num_to_trade
	self.items_required = items_required
	
	var trade_text: String = ""

	if prompt != null:
		trade_text = prompt[0].to_upper()
		
		trade_text += "[color=red]"
		var size = items_required.keys().size()
		for i in range(0, size):
			var k = items_required.keys()[i]
			var num_required = items_required[k]
			if i == size - 1 and i != 0:
				trade_text += " AND "
			elif i != 0:
				trade_text += ", "
			trade_text += Items.prefix_amount(k, num_required).to_upper()
		trade_text += "[/color]"
		
		trade_text += prompt[1].to_upper()
		trade_text += "[color=green]"
		trade_text += Items.prefix_amount(item_to_trade, num_to_trade).to_upper()
		trade_text += "[/color]"
		trade_text += prompt[2].to_upper()
	else:
		for k in items_required.keys():
			var num_required = items_required[k]
			if trade_text != "":
				trade_text += ", "
			trade_text += str(num_required, "x ", k.to_upper())
	
		trade_text += str(" -> ", num_to_trade, "x ", item_to_trade.to_upper())
	
	chatbox.set_text(trade_text)
	chatbox.set_visible(true)
	
	can_trade = check_trade_possible()

func _on_npc_removed():
	npc_count -= 1

func _on_trash_removed():
	trash_count -= 1