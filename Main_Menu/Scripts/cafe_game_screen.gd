extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"
@onready var floor_layer: TileMapLayer = $"Floor Layer"
@onready var floor_prop_layer: TileMapLayer = $"Floor Prop Layer"
@onready var wall_layer: TileMapLayer = $"Wall Layer"
@onready var wall_ornament_layer: TileMapLayer = $"Wall Ornament Layer"
@onready var ceiling_layer: TileMapLayer = $"Ceiling Layer"
@onready var peasant_scene = preload("res://Scenes/peasant_1.tscn")
@onready var obs_list : Array
@onready var used_tiles : Array
@onready var used_pos : Array
signal grid_made

func _ready():
	#Currently test code for drawing a grid over the floor layer
	grid_made.connect(_grid_sig_ex)
	_gen_map()
	grid_made.emit()

#Test code activated by signal
func _grid_sig_ex():
	print("Signal Emitted")
	
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
		var tile_pos = floor_prop_layer.map_to_local(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile_pos.x + 16, tile_pos.y))
	obs_tiles = wall_ornament_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = wall_ornament_layer.get_cell_tile_data(tile)
		var tile_pos = floor_prop_layer.map_to_local(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile_pos.x + 16, tile_pos.y))
	obs_tiles = ceiling_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = ceiling_layer.get_cell_tile_data(tile)
		var tile_pos = floor_prop_layer.map_to_local(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile_pos.x + 16, tile_pos.y))
	return used_tiles

#Calculates the map size by finding the top left and bottom right tiles, then computing length and height
func calc_map_size() -> Array:
	var minx = INF
	var maxx = -INF
	var miny = INF
	var maxy = -INF
	for tile in used_tiles:
		minx = min(minx, tile.x)
		maxx = max(maxx, tile.x)
		miny = min(miny, tile.y)
		maxy = max(maxy, tile.y)
	#Finding sign of maximum and minimum values to inform calculations in length and height
	var sinx = [signi(minx), signi(maxx)]
	var siny = [signi(miny), signi(maxy)]
	match sinx:
		[1, 1]:
			Globals.length = abs(minx - maxx)
		[0, 1]:
			Globals.length = maxx
		[-1, 1]:
			Globals.length = abs(minx) + maxx + 1
		[-1, 0]:
			Globals.length = abs(minx)
		[-1, -1]:
			Globals.length = abs(minx - maxx)
		_:
			push_error("Map parameters are fucked up.")
	match siny:
		[1, 1]:
			Globals.height = abs(miny - maxy)
		[0, 1]:
			Globals.height = maxy
		[-1, 1]:
			Globals.height = abs(miny) + maxy + 1
		[-1, 0]:
			Globals.height = abs(miny)
		[-1, -1]:
			Globals.height = abs(miny - maxy)
		_:
			push_error("Map parameters are fucked up.")
	return [Globals.length, Globals.height]
	

func _gen_map():
	getfloor_scanobs()
	#Creates list of tile positions in global position notation and corrects rounding issues
	for tile in used_tiles:
		var glo_pos = floor_layer.map_to_local(tile)
		glo_pos.x = glo_pos.x - 16
		used_pos.append(glo_pos)
	var cornerx = used_pos[0].x
	var cornery = used_pos[0].y
	calc_map_size()
	Globals.map_region = Rect2i(cornerx, cornery, Globals.length, Globals.height)
	Globals.astar_map.region = Globals.map_region
	Globals.astar_map.update()
	for obs in obs_list:
		Globals.astar_map.set_point_solid(obs)
		Globals.astar_map.update()
	print(Globals.map_region)
	print(len(obs_list))

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
