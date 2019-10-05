extends Area2D

signal npc_removed
signal trash_removed

func _on_object_entered(object):
	object.set_process(true)
	object.set_physics_process(true)

func _on_object_exited(object):
	
	if object.is_in_group("DontDisable"):
		return
	
	if object.is_in_group("NPC"):
		object.queue_free()
		emit_signal("npc_removed")
	if object.is_in_group("Trash"):
		object.queue_free()
		emit_signal("trash_removed")
	elif object.is_in_group("Deletable"):
		object.queue_free()
	else:
		object.set_process(false)
		object.set_physics_process(false)
