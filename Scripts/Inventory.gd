extends Node
class_name Inventory

signal item_changed(item, count)

var objects: Dictionary

func _init():
	objects = Dictionary()

func add(item: String, count: int):
	print("Added ", count, " ", item)
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