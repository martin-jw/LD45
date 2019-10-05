extends Area2D

signal removed

onready var camera: Camera2D = $"../Camera"

func interact(player: Player):
	player.inventory.add("clip", 1)
	emit_signal("removed")
	queue_free()
	
func _process(delta: float):
	
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y