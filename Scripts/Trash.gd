extends Area2D

signal removed

onready var camera: Camera2D = $"../Camera"

func on_closest_leave(player):
	$"Node2D/InteractMarker".visible = false

func on_closest_enter(player):
	$"Node2D/InteractMarker".visible = true

func interact(player):
	
	if randf() < 0.75:
		player.inventory.add("clip", 1)
	else:
		player.inventory.add("food", 1)
	
	player.get_node("Pickup Sound").play()
	emit_signal("removed")
	queue_free()
	
func _process(delta: float):
	
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y