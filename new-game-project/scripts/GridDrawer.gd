extends Node2D

@export var grid_size: int = 64
@export var grid_color: Color = Color(1, 1, 1, 0.1)

func _draw():
	for x in range(0, 1280, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, 720), grid_color)
	for y in range(0, 720, grid_size):
		draw_line(Vector2(0, y), Vector2(1280, y), grid_color)

func _process(delta):
	queue_redraw()
