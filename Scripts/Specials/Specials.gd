extends Node

var scripts = [
	preload("res://Scripts/Specials/JobOffer.gd"),
	preload("res://Scripts/Specials/Trader.gd"),
	preload("res://Scripts/Specials/Addict.gd"),
]

func get_random_script():
	
	var ind = randi() % scripts.size()
	return scripts[ind]