extends KinematicBody2D

signal trade_started(trader, prompt, item_to_trade, num_to_trade, items_required)

export var speed: float = 100

onready var rect = $ColorRect
var camera: Camera2D
var path: PoolVector2Array
var city: Navigation2D

var item_to_trade: String
var num_to_trade: int
var items_required: Dictionary
var prompt: Array

var trading: bool = false
var traded: bool = false

func _ready():
	camera = $"../Camera"
	rect.color = Color(randf(), randf(), randf())
	
	city = get_node("../City")
	
	find_path()
	choose_trade()

func interact(player):
	if !traded:
		player.trading = true
		trading = true
		emit_signal("trade_started", self, prompt, item_to_trade, num_to_trade, items_required)

func choose_trade():

	var state = "normal"

	var trade_keys = Items.trades.keys()
	item_to_trade = get_rand_element(trade_keys)
	
	num_to_trade = get_rand_element(Items.trades[item_to_trade][state]["received"])
	var items = Items.trades[item_to_trade][state]["items"]
	var min_required = Items.trades[item_to_trade][state]["min_items"]
	
	var num_items_required = randi() % (items.keys().size() - min_required + 1) + min_required
	items_required = Dictionary()

	if num_items_required == items.keys().size():
		for k in items.keys():
			var num = get_rand_element(items[k])
			if num > 0:
				items_required[k] = num
	else:
		var keys = items.keys().duplicate()
		for i in range(0, num_items_required):
			var ind = randi() % keys.size()
			var k =  keys[ind]
			keys.remove(ind)

			var num = get_rand_element(items[k])
			if num > 0:
				items_required[k] = num
		while items_required.keys().size() == 0:
			var ind = randi() % keys.size()
			var k =  keys[ind]
			keys.remove(ind)

			var num = get_rand_element(items[k])
			if num > 0:
				items_required[k] = num
	
	var ind = randi() % items_required.keys().size()
	var prompt_item = items_required.keys()[ind]
	
	var prompts = Items.item_prompts.get(prompt_item)
	if prompts != null:
		
		var pind = randi() % prompts.size()
		prompt = prompts[pind]


func get_rand_element(array: Array):
	var ind = randi() % array.size()
	return array[ind]

func find_path():
	if city != null:
		var point = position + Vector2((randf() - 0.5) * 12800, (randf() - 0.5) * 12800)
		path = city.get_simple_path(position, point)

func _physics_process(delta):
	
	if !trading:
		if path.size() > 0:
			var diff: Vector2 = path[0] - position
			move_and_slide(diff.normalized() * speed)
			if diff.length_squared() < 1024:
				path.remove(0)
		else:
			find_path()
	
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y