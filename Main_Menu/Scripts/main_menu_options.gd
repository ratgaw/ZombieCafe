extends GridContainer

#Declaring scenes as variables for ease of changing
const loading_screen_path = "res://Scenes/loading_screen.tscn"
const main_game_path = "res://Scenes/main_menu.tscn"
const msettings_path = "res://Scenes/msettings_menu.tscn"

#Sets volume bar graphic to current volume when entering menu
func _ready() -> void:
	AudioServer.set_bus_volume_linear(Globals.master_bus,Globals.music_volume)

func _process(delta: float) -> void:
	pass

#Quits game
func _on_quit_pressed() -> void:
	get_tree().quit()

#Switches to main game screen
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file(loading_screen_path)

#Switches to settings menu
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(msettings_path)
