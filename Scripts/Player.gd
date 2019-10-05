extends KinematicBody2D
class_name Player

signal inventory_item_changed(item, count)

export var speed: float = 5.0

onready var inventory: Inventory = $Inventory
var interactables: Array = Array()

var trading: bool = false

onready var camera: Camera2D = $"../Camera"

func _process(delta: float):
	if Input.is_action_just_pressed("interact") && !trading:
		var smallest: float = 1000000;
		var obj: Object = null;
		for i in interactables:
			print(i)
			var dist = global_position.distance_squared_to(i.global_position)
			print(dist)
			if dist < smallest:
				smallest = dist
				obj = i
		if obj != null:
			print("Interacted!")
			obj.interact(self)

func _physics_process(delta: float):
	
	if !trading:
		var move_horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var move_vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
		var direction = Vector2(move_horizontal, move_vertical).normalized()
		move_and_slide(direction * speed)
	
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y
	
	#print("Player ", position)

func _on_interact_area_entered(area: Area2D):
	print(area.name)
	print(area.get_groups())
	if area.is_in_group("Interactable"):
		interactables.append(area)
	
func _on_interact_area_exited(area: Area2D):
	if area.is_in_group("Interactable"):
		var ind = interactables.find(area)
		if ind != -1:
			interactables.remove(ind)
			
func item_changed(item, count):
	emit_signal("inventory_item_changed", item, count)
		
		