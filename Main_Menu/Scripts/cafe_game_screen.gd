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

func _ready():
	var positions = floor_layer.find_tiles_with_custom_data("Obstacle", true)
	Globals.obstacles_pos.append_array(positions)
	print("Floor Layer obstacle positions - " + positions)
	positions = floor_prop_layer.find_tiles_with_custom_data("Obstacle", true)
	Globals.obstacles_pos.append_array(positions)
	print("Floor Prop Layer obstacle positions - " + positions)
	positions = wall_layer.find_tiles_with_custom_data("Obstacle", true)
	Globals.obstacles_pos.append_array(positions)
	print("Wall Layer obstacle positions - " + positions)
	positions = wall_ornament_layer.find_tiles_with_custom_data("Obstacle", true)
	Globals.obstacles_pos.append_array(positions)
	print("Wall Ornament Layer obstacle positions - " + positions)
	positions = ceiling_layer.find_tiles_with_custom_data("Obstacle", true)
	Globals.obstacles_pos.append_array(positions)
	print("Ceiling Layer obstacle positions - " + positions)
	print(Globals.obstacles_pos)

func find_tiles_with_obstacle_tag(tilemap: TileMap, key: bool = true) -> Array:
	var tileset: TileSet = tilemap.tile_set
	
	var i: int = 1
	while i < 10:
		for cell in tilemap.get_used_cells(i):
			var source_id = tilemap.get_cell_source_id(i, cell)
			if source_id == -1:
				

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
