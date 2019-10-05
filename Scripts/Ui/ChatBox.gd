extends MarginContainer

onready var label = $"TextureRect/Label"

func set_text(text: String):
	label.text = text