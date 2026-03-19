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
	#scan_layer(floor_layer)
	scan_layer(wall_layer)
	print(obs_list)
	if obs_list.is_empty():
		emit_signal("grid_made")
	await grid_made
	print("Grid signal emitted correctly.")
	
#Function scans TileMapLayer for all used tiles & looks for any labelled as an obstacle, returns list of used tile positions
func scan_layer(layer: TileMapLayer) -> Array:
	used_tiles = layer.get_used_cells()
	if layer == floor_layer:
		print("Used floor layer.")
		return used_tiles
	else:
		print("Didn't use floor layer.")
		for tile in used_tiles:
			var tile_pos = layer.get_cell_tile_data(tile)
			if tile_pos.get_custom_data("Obstacle"):
				obs_list.append(tile)
		return used_tiles

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
