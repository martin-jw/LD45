extends Node2D

func set_text(text):
	$"Node2D/Label".text = text

func set_color(color):
	$"Node2D/Label".self_modulate = color