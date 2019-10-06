extends MarginContainer

onready var label = $"TextureRect/Label"
onready var yes_option = $"TextureRect/MarginContainer/HBoxContainer/YesOption"

func set_text(text: String):
	label.bbcode_text = text
	
func set_yes_available(available: bool):
	if available:
		yes_option.visible = true
	else:
		yes_option.visible = false