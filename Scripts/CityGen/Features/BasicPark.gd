extends CityFeature

func set_tiles(tilemap, x, y):
	tilemap.set_cell(x + 2, y + 2, 0, false, false, false, Vector2(0, 1))