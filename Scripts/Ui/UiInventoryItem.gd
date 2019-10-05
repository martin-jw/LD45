extends HBoxContainer

onready var label = $"PanelContainer/MarginContainer/Label"
onready var tex_rect = $"Panel/TextureRect"

func set_texture(texture):
	tex_rect.set_texture(texture)

func set_count(count: int):
	label.text = str("x", count)