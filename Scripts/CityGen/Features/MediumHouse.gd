extends CityFeature

func set_tiles(tilemap, x, y):
	set_base(tilemap, x, y)
	set_pavement(tilemap, x, y)

func get_size() -> Vector2:
	return Vector2(2, 2)

func has_entities() -> bool:
	return true