extends Node2D

export var amplitude: float = 16.0
export var time_mod: float = 3.0

var time_passed: float = 0

func _process(delta: float):
	
	time_passed += delta * time_mod
	position.y = sin(time_passed) * amplitude