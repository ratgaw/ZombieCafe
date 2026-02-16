extends Node2D

@onready var astar: AStarGrid2D
var npc_route: Array

#Creates an empty pathfinding grid with the desired settings to be used and changed by NPC pathfinding functions
func _enter_tree():
	astar = AStarGrid2D.new()
	astar.cell_size = Vector2(32, 32)
	astar.region = Globals.map_bounds
	astar.default_compute_heuristic = 1
	astar.diagonal_mode = 1
	astar.jumping_enabled = true
	astar.update()

#Finds size of map
func find_map_bounds(tilemap: TileMapLayer) -> Rect2i:
	var used_cells := tilemap.get_used_cells()
	var min_x := INF
	var min_y := INF
	var min_cx := INF
	var min_cy := INF
	var max_cx := -INF
	var max_cy := -INF
	var width : int
	var height : int
	
	for cell in used_cells:
		var glo_pos = to_global(tilemap.map_to_local(cell))
		print(glo_pos)
		min_x = min(min_x, glo_pos.x)
		min_y = min(min_y, glo_pos.y)
		min_cx = min(min_cx, cell.x)
		min_cy = min(min_cy, cell.y)
		max_cx = max(max_cx, cell.x)
		max_cy = max(max_cy, cell.y)
	
	if min_cx < 0 and max_cx < 0:
		width = (abs(min_cx) - abs(max_cx)) * 32
	elif min_cx < 0 and max_cx >= 0:
		width = (abs(min_cx) + max_cx + 1) * 32
	else:
		width = (min_cx + max_cx + 1) * 32
	
	if min_cy < 0 and max_cy < 0:
		height = (abs(min_cy) - abs(max_cy)) * 32
	elif min_cy < 0 and max_cy >= 0:
		height = (abs(min_cy) + max_cy) * 32
	else:
		height = (min_cy + max_cy) * 32
	
	print(astar.cell_size)
	Globals.map_bounds = Rect2i(min_x, min_y, width, height)
	return Globals.map_bounds

#Scans all TileMapLayers of a scene to fully assemble the list of obstacles on the map
func find_map_obs(floor: TileMapLayer, floor_prop: TileMapLayer, wall: TileMapLayer, wall_prop: TileMapLayer, ceiling: TileMapLayer) -> Array:
	obs_value_scan_layer(floor)
	obs_value_scan_layer(floor_prop)
	obs_value_scan_layer(wall)
	obs_value_scan_layer(wall_prop)
	obs_value_scan_layer(ceiling)
	return Globals.obstacles_pos

#Updates pathfinding grid based on current map
func update_map(map: Rect2i, obstacles: Array):
	astar.region = map
	for obs in obstacles:
		astar.set_point_solid(obs, true)
	astar.update()

#Scans a TileMapLayer for every tile labeled as an obstacle and adds it to global list of obstacles
func obs_value_scan_layer(tilemap: TileMapLayer) -> Array:
	for tile in tilemap.get_used_cells():
		var used_tile_data := tilemap.get_cell_tile_data(tile)
		if used_tile_data == null:
			pass
		elif used_tile_data.get_custom_data("Obstacle"):
			Globals.obstacles_pos.append(tile)
	return Globals.obstacles_pos
