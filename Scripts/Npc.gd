extends KinematicBody2D

signal trade_started(trader, prompt, item_to_trade, num_to_trade, items_required)

export var speed: float = 100
onready var sprite: Sprite = $Sprite
onready var talk_sound = $TalkSound

var camera: Camera2D
var path: PoolVector2Array
var city: Navigation2D

var item_to_trade: String
var num_to_trade: int
var items_required: Dictionary
var prompt: Array

var trading: bool = false
var traded: bool = false

var previous_position: Vector2
var movement_in_frame: Vector2
var facing_angle: float = PI / 2

var base_frame: int = 0
var move_frame: int = 0

var frame_time: float = 0

func _ready():
	camera = $"../Camera"
	previous_position = position
	
	city = get_node("../City")
	
	find_path()
	choose_trade()
	find_random_sprite()

var sprites = [
	"npc1.png",
	"npc2.png",
	"npc3.png",
	"npc4.png",
	"npc5.png",
	"npc6.png",
	"npc7.png",
	"npc8.png",
	"npc9.png",
	"npc10.png",
	"npc11.png",
	"npc12.png",
	"npc13.png",
]
	
func find_random_sprite():
	var ind = randi() % sprites.size()
	sprite.texture = load("res://Textures/npc/" + sprites[ind])

func interact(player):
	if !traded:
		player.trading = true
		trading = true
		talk_sound.play()
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

func _process(delta):

	if movement_in_frame.length() > 0:
		facing_angle = movement_in_frame.angle()

	var p = PI / 4
	
	if facing_angle >= -p and facing_angle < p:
		base_frame = 9
	elif facing_angle >= p and facing_angle < 3*p:
		base_frame = 0
	elif facing_angle >= 3*p or facing_angle < -3*p:
		base_frame = 27
	else:
		base_frame = 18

	if movement_in_frame.length() > speed * delta / 4:
		frame_time += delta
		if frame_time >= 0.150:
			if move_frame < 8:
				move_frame += 1
			else:
				move_frame = 1
			frame_time -= 0.1
	else:
		move_frame = 0

	sprite.frame = base_frame + move_frame
	movement_in_frame = position - previous_position
	previous_position = position

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