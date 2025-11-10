extends GridContainer

@onready var volume_display: ProgressBar = $"Volume Control/Volume Display"
@onready var volume_slider: HSlider = $"Volume Control/Volume Slider"

#Sets volume slider graphic to current volume level and adjusts volume to volume level set in global
func _ready() -> void:
	volume_slider.value = Globals.music_volume * 100
	AudioServer.set_bus_volume_linear(Globals.master_bus,Globals.music_volume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Controls volume
func _on_volume_slider_value_changed(value: float) -> void:
	volume_display.value = value
	var cvalue = value * 0.01
	#setting global volume variable to changed volume level and adjusts current volume
	AudioServer.set_bus_volume_linear(Globals.master_bus, cvalue)
	Globals.music_volume = cvalue
	
func _on_back_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://ZScenes/Main Menu.tscn")
