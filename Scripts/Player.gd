extends KinematicBody2D
class_name Player

onready var step: AudioStreamPlayer2D = $Step

signal inventory_item_changed(item, count)

export var speed: float = 5.0

onready var inventory: Inventory = $Inventory
var interactables: Array = Array()

var trading: bool = false

var clothes_level: int = 0
var in_control: bool = false

var clothes_textures: Array = [
	preload("res://Textures/player.png"),
	preload("res://Textures/player_basic.png"),
]

var previous_position: Vector2
var movement_in_frame: Vector2
var facing_angle: float = PI / 2

var items_per_second: Dictionary = Dictionary()
var items_accum: Dictionary = Dictionary()

var trades: Array = Array()
var trade_times: Array = Array()

var closest_inter = null

onready var camera: Camera2D = $"../Camera"
onready var sprite: Sprite = $Sprite

var base_frame: int = 0
var move_frame: int = 0

var frame_time: float = 0

func _ready():
	previous_position = position

var time_since_trades: float = 0
	
func _process(delta: float):
	if !trading:
		var smallest: float = 1000000;
		var obj: Object = null;
		for i in interactables:
			var dist = global_position.distance_squared_to(i.global_position)
			if dist < smallest:
				smallest = dist
				obj = i

		if obj != null and obj != closest_inter:
			if closest_inter != null:
				closest_inter.on_closest_leave(self)
			closest_inter = obj
			closest_inter.on_closest_enter(self)

		if Input.is_action_just_pressed("interact") and in_control:
			if closest_inter != null:
				obj.interact(self)
	else:
		if closest_inter != null:
			closest_inter.on_closest_leave(self)
			closest_inter = null
			
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
		if frame_time >= 0.075:
			if move_frame < 8:
				move_frame += 1
			else:
				move_frame = 1
				
			if move_frame == 3 or move_frame == 7:
				step.play()
			frame_time -= 0.1
	else:
		move_frame = 0

	sprite.frame = base_frame + move_frame
	
func found_clothes(clothes):
	var level = Items.clothes_levels[clothes]
	if clothes_level < level:
		clothes_level = level
		if clothes_level < clothes_textures.size():
			$Sprite.set_texture(clothes_textures[clothes_level])

func add_item_per_second(item, amount_per_second):
	if !items_per_second.has(item):
		items_per_second[item] = amount_per_second
		items_accum[item] = 0
	else:
		items_per_second[item] += amount_per_second

func add_trade(item_to_consume, amount, item_to_give):
	trades.append([item_to_consume, amount, item_to_give])
	trade_times.append(0)

func _physics_process(delta: float):
	
	if !trading and in_control:
		var move_horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var move_vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
		var direction = Vector2(move_horizontal, move_vertical).normalized()
		move_and_slide(direction * speed)

	for k in items_per_second:
		var change = items_per_second[k]
		items_accum[k] += change * delta
		while items_accum[k] > 1.0:
			inventory.add(k, 1)
			items_accum[k] -= 1
	
	time_since_trades += delta

	if time_since_trades >= 1:
		for i in range(0, trades.size()):
			trade_times[i] += time_since_trades
			if trade_times[i] >= 5.0:
				var item_to_consume = trades[i][0]
				var amount = trades[i][1]
				var item_to_give = trades[i][2]
				if inventory.get_count(item_to_consume) >= amount:
					inventory.remove(item_to_consume, amount)
					inventory.add(item_to_give, 1)
					trade_times[i] = 0.0
		time_since_trades = 0
	
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y
		
	movement_in_frame = position - previous_position
	previous_position = position
	
	#print("Player ", position)

func _on_interact_area_entered(area: Area2D):
	if area.is_in_group("Interactable"):
		interactables.append(area)
	
func _on_interact_area_exited(area: Area2D):
	if area.is_in_group("Interactable"):
		var ind = interactables.find(area)
		if ind != -1:
			if interactables[ind] == closest_inter:
				closest_inter.on_closest_leave(self)
				closest_inter = null
			interactables.remove(ind)
			
func item_changed(item, count):
	emit_signal("inventory_item_changed", item, count)
		
		