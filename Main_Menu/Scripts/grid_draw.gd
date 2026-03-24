extends Node2D

@onready var floor_layer: TileMapLayer = $"../Floor Layer"
@onready var parent = get_parent()

func _ready():
	z_index = 12
	queue_redraw()

func _draw():
	for tile in parent.used_tiles:
		var glo_pos = floor_layer.map_to_local(tile)
		glo_pos.x = glo_pos.x - 16
		print(tile)
		print(glo_pos)
		draw_rect(Rect2i(glo_pos.x, glo_pos.y, 32, 32), Color(0.2, 0.8, 0.2), false)
