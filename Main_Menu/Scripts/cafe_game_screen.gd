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
signal grid_made

func _ready():
	#Currently test code for drawing a grid over the floor layer
	grid_made.connect(_grid_sig_ex)
	getfloor_scanobs()
	if obs_list.is_empty():
		print("Function doesn't work right.")
	else:
		grid_made.emit()

#Test code activated by signal
func _grid_sig_ex():
	print("Grid signal emitted correctly, also there's obstacles.")
	
#Scans all layers to find floor tiles and all tiles marked as obstacles in other layers, returns floor pos list
func getfloor_scanobs() -> Array:
	used_tiles = floor_layer.get_used_cells()
	var obs_tiles = floor_prop_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_pos = floor_prop_layer.get_cell_tile_data(tile)
		if tile_pos.get_custom_data("Obstacle"):
			obs_list.append(tile)
	obs_tiles = wall_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_pos = wall_layer.get_cell_tile_data(tile)
		if tile_pos.get_custom_data("Obstacle"):
			obs_list.append(tile)
	obs_tiles = wall_ornament_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_pos = wall_ornament_layer.get_cell_tile_data(tile)
		if tile_pos.get_custom_data("Obstacle"):
			obs_list.append(tile)
	obs_tiles = ceiling_layer.get_used_cells()
	for tile in obs_tiles:
		var tile_pos = ceiling_layer.get_cell_tile_data(tile)
		if tile_pos.get_custom_data("Obstacle"):
			obs_list.append(tile)
	return used_tiles

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
