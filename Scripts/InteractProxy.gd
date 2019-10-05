extends Node

signal interacted(player)

func interact(player: Player):
	emit_signal("interacted", player)