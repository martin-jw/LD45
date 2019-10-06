extends Node

signal interacted(player)

func interact(player: Player):
	emit_signal("interacted", player)
	
func on_closest_leave(player):
	$"../Node2D/InteractMarker".visible = false

func on_closest_enter(player):
	if !get_parent().traded:
		$"../Node2D/InteractMarker".visible = true