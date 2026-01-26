extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"
@onready var floor_layer: TileMapLayer = $"Floor Layer"
@onready var floor_prop_layer: TileMapLayer = $"Floor Prop Layer"
@onready var wall_layer: TileMapLayer = $"Wall Layer"
@onready var wall_ornament_layer: TileMapLayer = $"Wall Ornament Layer"
@onready var ceiling_layer: TileMapLayer = $"Ceiling Layer"
@onready var peasant_scene = preload("res://Scenes/peasant_1.tscn")
@onready var order_station_marker: Marker2D = $"Order Station Marker"
@onready var astar: AStarGrid2D
@onready var map_bounds: Rect2i

func _ready():
	obs_value_scan_layer(floor_layer)
	obs_value_scan_layer(floor_prop_layer)
	obs_value_scan_layer(wall_layer)
	obs_value_scan_layer(wall_ornament_layer)
	obs_value_scan_layer(ceiling_layer)
	find_map_bounds(floor_layer)
	astar.new()
	astar.region = map_bounds
	astar.cell_size = Vector2(32, 32)
	for obs in Globals.obstacles_pos:
		astar.set_point_solid(obs, true)
	astar.default_compute_heuristic = 1
	astar.diagonal_mode = 1
	astar.jumping_enabled = true
	astar.update()

#Scans a TileMapLayer for every tile labeled as an obstacle and adds it to global list of obstacles
func obs_value_scan_layer(tilemap: TileMapLayer) -> Array:
	for tile in tilemap.get_used_cells():
		var used_tile_data := tilemap.get_cell_tile_data(tile)
		if used_tile_data == null:
			pass
		elif used_tile_data.get_custom_data("Obstacle"):
			Globals.obstacles_pos.append(tile)
	print(Globals.obstacles_pos)
	return Globals.obstacles_pos

#Finds size of the map
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
	
	map_bounds = Rect2i(Vector2i(min_x, min_y), Vector2i(max_x - min_x + 1, max_y - min_y + 1))
	return map_bounds

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
