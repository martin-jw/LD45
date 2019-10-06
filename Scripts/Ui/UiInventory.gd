extends MarginContainer

onready var container = $"VBoxContainer/VBoxContainer"

const ui_item: PackedScene = preload("res://Scenes/Ui/UiInventoryItem.tscn")
var ui_items: Dictionary = Dictionary()

func update_item(item, count):
	set_visible(true)
	if ui_items.has(item):
		var ui_obj = ui_items[item]
		ui_obj.set_count(count)
	elif count > 0:
		var ui_obj = ui_item.instance()
		container.add_child(ui_obj)
		ui_obj.set_count(count)
		ui_obj.set_texture(Items.item_textures.get(item, preload("res://Textures/Items/paperclip.png")))
		ui_items[item] = ui_obj
		
		