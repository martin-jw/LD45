extends Node
class_name Inventory

const InventoryPopup = preload("res://Scenes/InventoryPopup.tscn")

signal item_changed(item, count)
signal found_clothes(item)

var objects: Dictionary

func _init():
	objects = Dictionary()

func _ready():
	pass

func add(item: String, count: int):

	if item.substr(0, 8).nocasecmp_to("clothes_") == 0:
		emit_signal("found_clothes", item)
		return
	var num = objects.get(item, 0)
	num += count
	objects[item] = num
	
	var popup = InventoryPopup.instance()
	popup.position = Vector2(0, -264)
	popup.set_text(str("+", count, " ", Items.pluralize(item, count)))
	get_parent().add_child(popup)
	
	emit_signal("item_changed", item, num)

func get_count(item: String) -> int:
	return objects.get(item, 0)

func remove(item: String, count: int) -> int:
	var num = get_count(item)
	if num == 0 or count == 0:
		return 0
	if num < count:
		objects[item] = 0
		emit_signal("item_changed", item, 0)
		return num
	else:
		num -= count
		objects[item] = num
		emit_signal("item_changed", item, num)
		return count