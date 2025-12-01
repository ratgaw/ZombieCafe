extends GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_linear(Globals.master_bus,Globals.music_volume)

func _process(delta: float) -> void:
	pass

#Quits game
func _on_quit_pressed() -> void:
	get_tree().quit()

#Switches to main game screen
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/cafe_game.tscn")

#Switches to settings menu
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Settings Menu.tscn")
