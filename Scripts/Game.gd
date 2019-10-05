extends Node2D

export var max_npc_count: int = 10
export var max_trash_count: int = 5
export var trash_spawn_interval: float = 2.5

onready var city = $City
onready var chatbox = $"UILayer/ChatBox"
onready var ui_inventory = $"UILayer/UiInventory"
var camera: Camera
var player

const Player = preload("res://Scenes/Player.tscn")
const Npc = preload("res://Scenes/NPC.tscn")
const Trash = preload("res://Scenes/Trash.tscn")

var npc_count: int = 0

var trash_timer: float = trash_spawn_interval
var trash_count: int = 0

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

func spawn_npc():
	
	var x = rand_range(-1280, 1280)
	var y = rand_range(-720, 720) * ((randi() % 2) * 2 - 1)

	if x > -672 and x < 672 and y > -360 and y < 616:
		return

	var pos = camera.position - Vector2(0, 128) + Vector2(x, y)
	
	if city.get_closest_point(pos) == pos:
		var npc = Npc.instance()
		npc.position = pos
		
		npc.connect("trade_started", self, "begin_trade")
		
		call_deferred("add_child", npc)
		npc_count += 1

func _process(delta):
	trash_timer += delta
	
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

func check_trade_possible():
	if trader == null:
		return false
	
	for k in items_required:
		if player.inventory.get_count(k) < items_required[k]:
			return false
	
	return true

func begin_trade(trader: Node2D, item_to_trade: String, num_to_trade: int, items_required: Dictionary):

	self.trader = trader
	self.item_to_trade = item_to_trade
	self.num_to_trade = num_to_trade
	self.items_required = items_required

	var trade_text: String = ""
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