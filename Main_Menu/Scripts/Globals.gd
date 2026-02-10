extends Node

#Volume control variables
var master_bus = AudioServer.get_bus_index("Master")
var music_volume = 0.5
var unmute = true

#Screen tracking
var last_scene = "res://Scenes/main_menu.tscn"

#NPC pathfinding variables
var order_pos = Vector2(-234, -67).floor()
var start_pos = Vector2(112, -198).floor()
var obstacles_pos: Array[Vector2i] = []
var map_bounds: Rect2i
