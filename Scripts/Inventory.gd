extends Node
class_name Inventory

signal item_changed(item, count)
signal found_clothes(item)

var objects: Dictionary

func _init():
	objects = Dictionary()

func _ready():
	add("clip", 30)
	add("food", 30)
	add("pencil", 15)
	add("pen", 1)
	add("clothes_basic", 1)
	add("job", 15)

func add(item: String, count: int):

	if item.substr(0, 8).nocasecmp_to("clothes_") == 0:
		emit_signal("found_clothes", item)
		return
	var num = objects.get(item, 0)
	num += count
	objects[item] = num
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