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
	print("Game screen booted, but didn't draw.")
	await "map_made"
	for cell in Globals.used_cells:
		var cpos = Vector2i(cell)
		var rect = Rect2i(cpos.x, cpos.y, 32, 32)
		draw_rect(rect, Color(0.1, 0.6, 0.8), false, 0.2)
	print("Game screen should have finished drawing grid.")

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
