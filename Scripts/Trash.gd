extends Area2D

signal removed

onready var camera: Camera2D = $"../Camera"

func interact(player):
	
	if randf() < 0.75:
		player.inventory.add("clip", 1)
	else:
		player.inventory.add("food", 1)
	emit_signal("removed")
	queue_free()
	
func _process(delta: float):
	
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y