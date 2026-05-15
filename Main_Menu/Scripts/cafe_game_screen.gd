extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"
@onready var floor_layer: TileMapLayer = $"Floor Layer"
@onready var floor_prop_layer: TileMapLayer = $"Floor Prop Layer"
@onready var overshadow_prop_layer: TileMapLayer = $"Overshadow Prop Layer"
@onready var wall_layer: TileMapLayer = $"Wall Layer"
@onready var wall_ornament_layer: TileMapLayer = $"Wall Ornament Layer"
@onready var ceiling_layer: TileMapLayer = $"Ceiling Layer"
@onready var peasant1 = preload("res://Scenes/peasant_1.tscn")
@onready var zombie1 = preload("res://Scenes/zombie_1.tscn")
@onready var obs_list : Array
@onready var used_tiles : Array
@onready var used_pos : Array
@onready var chair_list : Array
@onready var chair_pos : Array
@onready var map_sig : bool = false
@onready var map_origin
@onready var line : Array
@onready var orderpath
@onready var cellpath
@onready var pos = 0
@onready var new_NPC
signal order_made
signal move_line
signal draw_grid

#Connects order and map genration signals to NPC on scene start, generates map for NPC pathfinding use
# and sends signal that map has been generated to NPCs
#Currently spawns a new peasant NPC every 3 seconds
func _ready():
	draw_grid.connect($grid_draw._draw)
	move_line.connect(_line_movement)
	_gen_map()
	orderpath = Globals.astar_map.get_point_path(Globals.entrance, Globals.order)
	cellpath = Globals.astar_map.get_id_path(Globals.entrance, Globals.order)
	for cell in cellpath:
		Globals.astar_map.set_point_weight_scale(cell, 100)
	map_sig = true
	var ttimer = Timer.new()
	add_child(ttimer)
	ttimer.wait_time = 3.0
	ttimer.timeout.connect(_gen_peasant)
	ttimer.start()

#Scans all layers to find floor tiles and all tiles marked as obstacles in other layers, returns floor pos list
func getfloor_scanobs() -> Array:
	used_tiles = floor_layer.get_used_cells()
	map_origin = Vector2(used_tiles[0].x * 32, used_tiles[0].y * 32)
	#Scans floor prop & overshadow prop layer for locations of used cells then adds those marked
	# as obstacles or chairs to their respective lists
	var obs_tiles = floor_prop_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = floor_prop_layer.get_cell_tile_data(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile))
		elif tile_dat.get_custom_data("Chair"):
			chair_list.append(Vector2i(tile))
	obs_tiles = overshadow_prop_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_dat = overshadow_prop_layer.get_cell_tile_data(tile)
		if tile_dat.get_custom_data("Obstacle"):
			obs_list.append(Vector2i(tile))
		elif tile_dat.get_custom_data("Chair"):
			chair_list.append(Vector2i(tile))
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
#Creates list of tile positions in global position notation and corrects rounding issues, used for grid drawing
	for tile in used_tiles:
		var glo_pos = floor_layer.map_to_local(tile)
		glo_pos.x = glo_pos.x - 16
		used_pos.append(glo_pos)

	for chair in chair_list:
		if floor_prop_layer.get_cell_source_id(chair) == -1:
			var glo_pos = overshadow_prop_layer.map_to_local(chair)
			glo_pos.x = glo_pos.x - 16
			chair_pos.append(glo_pos)
		else:
			var glo_pos = floor_prop_layer.map_to_local(chair)
			glo_pos.x = glo_pos.x - 16
			chair_pos.append(glo_pos)
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
func _input(user_input: InputEvent) -> void:
	if user_input.is_action_pressed("options_menu"):
			game_options_menu.popup(Rect2i(0,0,300,100))
	if user_input.is_action_pressed("test_order"):
			order_made.emit()
	if user_input.is_action_pressed("Display Grid"):
		draw_grid.emit()

#Generates new peasant at the front entrance
func _gen_peasant():
	randomize()
	var choice = randi() % 10
	if choice < 4:
		new_NPC = zombie1.instantiate()
	else:
		new_NPC = peasant1.instantiate()
	new_NPC.position = Vector2(112, -208)
	add_child(new_NPC)

func _line_movement():
	for line_pos in range(len(line)):
		await get_tree().create_timer(0.5).timeout
		if pos < len(line):
			pos = line_pos
		else:
			return
