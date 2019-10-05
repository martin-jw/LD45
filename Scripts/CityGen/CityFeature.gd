extends Node2D
class_name CityFeature

var camera: Camera2D

func _ready():
	z_index = position.y / 128
	z_as_relative = true
	
	camera = get_tree().get_root().find_node("Camera", true, false)
	if camera != null:
		z_index = position.y - camera.position.y
	set_process(false)
	
	
func _process(delta):
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y

func get_size() -> Vector2:
	return Vector2(1, 1)

func set_tiles(tilemap, x, y):
	set_pavement(tilemap, x, y)
	
func set_pavement(tilemap, x, y):
	for dx in range(0, get_size().x * Config.PLOT_SIZE):
		for dy in range(0, get_size().y * Config.PLOT_SIZE):
			
			if dx == 0 or dx == get_size().x * Config.PLOT_SIZE - 1 or dy == 0 or dy == get_size().y * Config.PLOT_SIZE - 1:
				 tilemap.set_cell(x + dx, y + dy, 0, false, false, false, Vector2(0, 1))

func set_base(tilemap, x, y):
	for dx in range(0, get_size().x * Config.PLOT_SIZE):
		for dy in range(0, get_size().y * Config.PLOT_SIZE):
			 tilemap.set_cell(x + dx, y + dy, 0, false, false, false, Vector2(0, 3))

func has_entities() -> bool:
	return false