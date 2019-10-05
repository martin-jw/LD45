extends "res://Scripts/CityGen/CityFeature.gd"

func has_entities() -> bool:
	return true
	
func set_tiles(tilemap, x, y):
	set_base(tilemap, x, y)
	set_pavement(tilemap, x, y)