extends Node

var astar: AStarGrid2D
var npc_route: Array

#Creates an empty pathfinding grid with the desired settings to be used and changed by NPC pathfinding functions
func _ready() -> void:
	astar.new()
	astar.region = Globals.map_bounds
	astar.cell_size = Vector2(32, 32)
	astar.default_compute_heuristic = 1
	astar.diagonal_mode = 1
	astar.jumping_enabled = true
	astar.update()

#Finds size of map
func find_map_bounds(tilemap: TileMapLayer) -> Rect2i:
	var used_cells := tilemap.get_used_cells()
	var min_x := INF
	var min_y := INF
	var max_x := -INF
	var max_y := -INF
	
	for cell in used_cells:
		min_x = min(min_x, cell.x)
		min_y = min(min_y, cell.y)
		max_x = max(max_x, cell.x)
		max_y = max(max_y, cell.y)
	
	Globals.map_bounds = Rect2i(Vector2i(min_x, min_y), Vector2i(max_x - min_x + 1, max_y - min_y + 1))
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
