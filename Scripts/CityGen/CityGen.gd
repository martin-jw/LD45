extends Node2D

onready var roadmap = $RoadMap
onready var tilemap = $TileMap

var spawnpoint: Vector2 
var size: Vector2

var features: Array = [
	preload("res://Scenes/CityFeatures/SmallHouse.tscn"),
	preload("res://Scenes/CityFeatures/MediumHouse.tscn"),
]

func _ready():
	randomize()

	roadmap.MAP_WIDTH = 20
	roadmap.MAP_HEIGHT = 20
	size = Vector2(roadmap.MAP_WIDTH * Config.PLOT_SIZE, roadmap.MAP_HEIGHT * Config.PLOT_SIZE)

	print("Generating roadmap...")
	roadmap.generate()
	
	print("Getting spawnpoint...")
	spawnpoint = roadmap.get_spawnpoint()
	
	print("Filling plots...")
	fill_plots()
	
func get_spawnpoint():
	var spawn = spawnpoint * Config.PLOT_SIZE
	spawn.x *= tilemap.cell_size.x
	spawn.y *= tilemap.cell_size.y
	
	return spawn

func fill_plots():
	for x in range(0, roadmap.MAP_WIDTH):
		for y in range(0, roadmap.MAP_HEIGHT):
			if roadmap.get_tile_padded(x , y) == roadmap.PLOT:
				fill_with_compatible(x, y)

func fill_with_compatible(x, y):
	
	var found = false
	while not found:
		var ind = randi() % features.size()
		
		var feature = features[ind].instance()
		
		var compatible = true
		var size = feature.get_size()
		for dx in range(0, size.x):
			for dy in range(0, size.y):
				if roadmap.get_tile_padded(x + dx, y + dy) != roadmap.PLOT:
					compatible = false
		
		if compatible:
			feature.position = Vector2(x * Config.PLOT_SIZE * tilemap.cell_size.x, y * Config.PLOT_SIZE * tilemap.cell_size.y)
			feature.set_tiles(tilemap, x * Config.PLOT_SIZE, y * Config.PLOT_SIZE)
			
			for dx in range(0, size.x):
				for dy in range(0, size.y):
					roadmap.set_tile(x + dx, y + dy, roadmap.FILLED_PLOT)
		
			if feature.has_entities():
				call_deferred("add_child", feature)
			found = true