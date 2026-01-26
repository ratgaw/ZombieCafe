extends Node

#declaring variables to be used over multiple scenes
var master_bus = AudioServer.get_bus_index("Master")
var music_volume = 0.5
var last_scene = "res://Scenes/main_menu.tscn"
var unmute = true
var order_pos = Vector2(-234, -67)
var start_pos = Vector2(112, -198)
var obstacles_pos: Array[Vector2i] = [] 
var astar: AStarGrid2D
