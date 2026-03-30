extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"
@onready var floor_layer: TileMapLayer = $"Floor Layer"
@onready var floor_prop_layer: TileMapLayer = $"Floor Prop Layer"
@onready var wall_layer: TileMapLayer = $"Wall Layer"
@onready var wall_ornament_layer: TileMapLayer = $"Wall Ornament Layer"
@onready var ceiling_layer: TileMapLayer = $"Ceiling Layer"
@onready var peasant: Peasant_1 = $"Customer Area/Peasant1"
@onready var peasant_scene = preload("res://Scenes/peasant_1.tscn")
@onready var obs_list : Array
@onready var used_tiles : Array
@onready var used_pos : Array
signal grid_made

func _ready():
	#Currently test code for connecting signal to child node for NPC pathfinding
	grid_made.connect(peasant._pathfind)
	_gen_map()
	grid_made.emit()
	
#Scans all layers to find floor tiles and all tiles marked as obstacles in other layers, returns floor pos list
func getfloor_scanobs() -> Array:
	used_tiles = floor_layer.get_used_cells()
	var obs_tiles = floor_prop_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = floor_prop_layer.get_cell_tile_data(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile))
	obs_tiles = wall_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = wall_layer.get_cell_tile_data(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile))
	obs_tiles = wall_ornament_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = wall_ornament_layer.get_cell_tile_data(tile)
		if tile_dat.get_custom_data("Obstacle") && Globals.astar_map.is_in_boundsv(tile):
			obs_list.append(Vector2i(tile))
	obs_tiles = ceiling_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = ceiling_layer.get_cell_tile_data(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile))
	return used_tiles

#Generates AstarGrid2D with size of floor layer and marks obstacles for pathfinding functions
func _gen_map():
	getfloor_scanobs()
#Creates list of tile positions in global position notation and corrects rounding issues, currently has no use
	for tile in used_tiles:
		var glo_pos = floor_layer.map_to_local(tile)
		glo_pos.x = glo_pos.x - 16
		used_pos.append(glo_pos)
#Sets map region to the size of the floor
	Globals.map_region = floor_layer.get_used_rect()
	Globals.astar_map.region = Globals.map_region
	Globals.astar_map.update()
#Marks obstacles in map, excluding those obstacles that are outside of the map's region
	for obs in obs_list:
		if Globals.astar_map.is_in_boundsv(obs):
			Globals.astar_map.set_point_solid(obs)
			Globals.astar_map.update()

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
