extends Node2D

@onready var ground_map = $GroundTileMap
@onready var object_map = $ObjectTileMap
@export var grid_size: int = 64

var selected_tile_id := 0  # which tile to place (e.g. floor)
var placing_on_objects := false  # false = ground, true = object layer

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var cell = Vector2i(floor(mouse_pos.x / grid_size), floor(mouse_pos.y / grid_size))

		if placing_on_objects:
			object_map.set_cell(cell, selected_tile_id)
		else:
			ground_map.set_cell(cell, selected_tile_id)

	if event is InputEventKey:
		match event.keycode:
			KEY_1:  # Switch to ground tiles
				placing_on_objects = false
				selected_tile_id = 0  # floor
			KEY_2:  # Switch to object tiles
				placing_on_objects = true
				selected_tile_id = 0  # wall
