extends Control

#declaring variables for moving graphics in menu
@onready var moving_clouds: Panel = $MovingClouds

# Sets music volume to volume level already set (0.0 by default)
func _ready() -> void:
	AudioServer.set_bus_volume_linear(Globals.master_bus,Globals.music_volume)
	
#Controls clouds sprites moving in background
func _process(delta: float) -> void:
	$MovingClouds.position += Vector2(2,0)
	if $MovingClouds.position >= Vector2(1200,0):
		$MovingClouds.position = Vector2(-1150,0)
