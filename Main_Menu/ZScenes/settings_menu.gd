extends Control

#Setting variables
@onready var volume_slider: ProgressBar = $"Settings Controls/Volume Settings/Volume Slider"

# Called when the node enters the scene tree for the first time.
#Sets graphics of volume slider to default of 50% & sets volume of music to whatever level it was set to previously
func _ready() -> void:
	volume_slider.value = Globals.music_volume * 100
	AudioServer.set_bus_volume_linear(Globals.master_bus,Globals.music_volume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#assigns volume slider graphic values to invisible slider input
func _on_volume_slider_2_value_changed(value: float) -> void:
	volume_slider.value = value
	var cvalue = value * .01
	AudioServer.set_bus_volume_linear(Globals.master_bus,cvalue)
	Globals.music_volume = cvalue

#Switches back to main menu on menu button press
func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://ZombieCafe/ZScenes/Main Menu.tscn")
