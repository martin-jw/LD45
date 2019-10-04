extends Node2D

export var num_road_tries: int = 400;

const PLOT = 0
const ROAD = 1
const HIGHWAY = 2
const OUTSIDE = 3

const MAP_WIDTH: int = 80
const MAP_HEIGHT: int = 50

var array: Array = Array()

func _ready():
	randomize()
	for i in range(0, MAP_WIDTH * MAP_HEIGHT):
		array.append(0)
		
	print(array.size())

	gen_highways()
	gen_roads()
	update()

func _draw():

	for y in range(0, MAP_HEIGHT):
		for x in range(0, MAP_WIDTH):
			var tile = get_tile(x, y)
			var color = Color.black
			if tile == HIGHWAY:
				color = Color.green
			if tile == ROAD:
				color = Color.white
				
			draw_rect(Rect2(x * 10, y * 10, 8, 8), color)

func set_tile(x: int, y: int, tile: int):
	array[x + y * MAP_WIDTH] = tile

func get_tile(x: int, y: int) -> int:
	return array[x + y * MAP_WIDTH]

func get_tile_padded(x: int, y: int) -> int:
	if x >= 0 and x < MAP_WIDTH and y >= 0 and y < MAP_HEIGHT:
		return get_tile(x, y)
	else:
		return OUTSIDE
	

func _set_highway(x: int, y: int):
	set_tile(x, y, HIGHWAY)
	set_tile(x + 1, y, HIGHWAY)
	set_tile(x + 1, y + 1, HIGHWAY)
	set_tile(x, y + 1, HIGHWAY)

func _get_neighbors(px, py) -> Array:
	var result: Array = Array()
	
	for x in range(px - 1, px + 2):
		for y in range(py - 1, py + 2):
			if not (x == px and y == py):
				result.append(get_tile_padded(x, y))
	return result

func _get_front_and_sides(x, y, dx, dy) -> Array:
	var result: Array = Array()
	
	if dx >= 0:
		result.append(get_tile_padded(x + 1, y))
	if dx <= 0:
		result.append(get_tile_padded(x - 1, y))
	if dy >= 0:
		result.append(get_tile_padded(x, y + 1))
	if dy <= 0:
		result.append(get_tile_padded(x, y - 1))
	return result

func _has_met_road(x, y, dx, dy) -> bool:
	var n = _get_front_and_sides(x, y, dx, dy)

	for t in n:
		if t == HIGHWAY or t == ROAD:
			return true
	
	return false

func gen_roads():
	for i in range(0, num_road_tries):

		var x = round(rand_range(1, MAP_WIDTH - 2))
		var y = round(rand_range(1, MAP_HEIGHT - 2))

		if get_tile(x, y) != PLOT:
			continue

		var n = _get_neighbors(x, y)
		var surrounded: bool = true
		for e in n:
			if e != PLOT:
				surrounded = false
				break

		if not surrounded:
			continue

		print(x, " ", y)

		var new = array.duplicate(true)
		new[x + y * MAP_WIDTH] = ROAD

		for dx in range(1, x):
			var nx = x - dx
			var ny = y
			new[nx + ny * MAP_WIDTH] = ROAD
			if _has_met_road(nx, ny, -dx, 0):
				array = new
				break

		new = array.duplicate(true)
		new[x + y * MAP_WIDTH] = ROAD

		for dx in range(1, MAP_WIDTH - x - 1):
			var nx = x + dx
			var ny = y
			new[nx + ny * MAP_WIDTH] = ROAD
			if _has_met_road(nx, ny, dx, 0):
				array = new
				break

		new = array.duplicate(true)
		new[x + y * MAP_WIDTH] = ROAD

		for dy in range(1, y):
			var nx = x
			var ny = y - dy
			new[nx + ny * MAP_WIDTH] = ROAD
			if _has_met_road(nx, ny, 0, -dy):
				array = new
				break

		new = array.duplicate(true)
		new[x + y * MAP_WIDTH] = ROAD

		for dy in range(1, MAP_HEIGHT - y - 1):
			var nx = x
			var ny = y + dy
			new[nx + ny * MAP_WIDTH] = ROAD
			if _has_met_road(nx, ny, 0, dy):
				array = new
				break

func gen_highways():

	var left_edge: int = round(rand_range(1, MAP_HEIGHT - 3))
	var right_edge: int = round(rand_range(1, MAP_HEIGHT - 3))

	var diff: int = right_edge - left_edge
	var cur_y: int = left_edge
	var since_last_step: int = 0;
	for x in range(0, MAP_WIDTH - 1):

		_set_highway(x, cur_y)

		if x == MAP_WIDTH - 3:
			if diff < 0:
				for y in range(right_edge, cur_y):
					_set_highway(x, y)
			elif diff > 0:
				for y in range(cur_y, right_edge + 1):
					_set_highway(x, y)
				
			cur_y = right_edge
		elif x < MAP_WIDTH - 5:
			if since_last_step >= 2 and randf() < 0.2:
				var step = floor(rand_range(2, 5)) * ((randi() % 2) * 2 - 1)
				
				if cur_y + step >= 1 and cur_y + step < MAP_HEIGHT - 2:
					if step < 0:
						for y in range(step, 0):
							_set_highway(x, cur_y + y)
					elif step > 0:
						for y in range(0, step + 1):
							_set_highway(x, cur_y + y)
					cur_y += step
					since_last_step = 0
				else:
					since_last_step += 1
			else:
				since_last_step += 1

		diff = right_edge - cur_y

	var top_edge: int = round(rand_range(1, MAP_WIDTH - 3))
	var bottom_edge: int = round(rand_range(1, MAP_WIDTH - 3))

	diff = bottom_edge - top_edge
	var cur_x: int = top_edge
	since_last_step = 0;
	for y in range(0, MAP_HEIGHT - 1):

		_set_highway(cur_x, y)

		if y == MAP_HEIGHT - 3:
			if diff < 0:
				for x in range(bottom_edge, cur_x):
					_set_highway(x, y)
			elif diff > 0:
				for x in range(cur_x, bottom_edge + 1):
					_set_highway(x, y)
				
			cur_x = bottom_edge
		elif y < MAP_HEIGHT - 5:
			if since_last_step >= 2 and randf() < 0.2:
				var step = floor(rand_range(2, 5)) * ((randi() % 2) * 2 - 1)
				
				if cur_x + step >= 1 and cur_x + step < MAP_WIDTH - 2:
					if step < 0:
						for x in range(step, 0):
							_set_highway(cur_x + x, y)
					elif step > 0:
						for x in range(0, step + 1):
							_set_highway(cur_x + x, y)
					cur_x += step
					since_last_step = 0
				else:
					since_last_step += 1
			else:
				since_last_step += 1

		diff = bottom_edge - cur_x
	
	var new = array.duplicate(true)
	
	for x in range(0, MAP_WIDTH):
		for y in range(0, MAP_HEIGHT):
			if get_tile(x, y) == HIGHWAY:
				var n = _get_neighbors(x, y)
				var surrounded: bool = true
				for e in n:
					if e != HIGHWAY:
						surrounded = false
						break
				
				if surrounded:
					new[x + y * MAP_WIDTH] = PLOT

	array = new

	