extends Node2D

#Volume control variables
var master_bus = AudioServer.get_bus_index("Master")
var music_volume = 0.5
var unmute = true

#Screen tracking
var last_scene = "res://Scenes/main_menu.tscn"

#Pathfinding variables for NPC pathfinding
var astar_map 
var map_region : Rect2i
var length : int
var height : int

#Initial empty grid created for pathfinding
func _enter_tree():
	astar_map = AStarGrid2D.new()
	astar_map.region = map_region
	astar_map.set_cell_size(Vector2(32, 32))
	astar_map.update()
