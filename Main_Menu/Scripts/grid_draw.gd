extends Node2D

#Entire node used to draw grid over map, conditions for grid startup to change later
@onready var floor_layer: TileMapLayer = $"../Floor Layer"
@onready var parent = get_parent()

#On node start sets any drawings to top of layers, showing it overtop any tiles and triggers draw function
func _ready():
	z_index = 12
	queue_redraw()

#Draws grid, pulls positions from parent, corrects position mismatch due to rounding, then displays
func _draw():
	for pos in parent.used_pos:
		draw_rect(Rect2i(pos.x, pos.y, 32, 32), Color(0.2, 0.8, 0.2), false)
