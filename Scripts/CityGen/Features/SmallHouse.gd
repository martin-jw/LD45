extends "res://Scripts/CityGen/CityFeature.gd"

onready var sprite = $Sprite

func _ready():
	._ready()
	find_random_sprite()

var sprites = [
	"house1.png",
	"house2.png",
	"house3.png",
	"house4.png",
	"house5.png",
	"house6.png",
]
	
func find_random_sprite():
	var ind = randi() % sprites.size()
	sprite.texture = load("res://Textures/House/" + sprites[ind])

func has_entities() -> bool:
	return true
	
func set_tiles(tilemap, x, y):
	set_base(tilemap, x, y)
	set_pavement(tilemap, x, y)