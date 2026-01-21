extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"
@onready var peasant_scene = preload("res://Scenes/peasant_1.tscn")
@onready var order_station_marker: Marker2D = $"Order Station Marker"
@onready var grid_display: Control = $"Grid Display"
@export var map: TileMapLayer
var astar_grid: AStarGrid2D



func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_size = map.tile_set.tile_size
	astar_grid.region = Rect2(Vector2.ZERO, ceil(get_viewport_rect().size / astar_grid.cell_size))
	astar_grid.update()
	
	for id in map.get_used_cells():
		var data = map.get_cell_tile_data(id)
		if data and data.get_custom_data('Obstacle'):
			astar_grid.set_point_solid(id)
	
	grid_display.grid = astar_grid

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
