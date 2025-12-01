extends PopupMenu

func _ready() -> void:
	if Globals.unmute:
		toggle_item_checked(2)

#Controls Game Options Menu options 
func _on_index_pressed(index: int) -> void:
	if index == 0:
		#Takes user back to main menu
		Globals.last_scene = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
	if index == 1:
		#Takes user to options menu
		Globals.last_scene = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file("res://Scenes/Settings Menu.tscn")
		#Quickly mutes and un-mutes master volume, resetting volume to default of 50% should volume be muted then unmuted
	if index == 2:
		toggle_item_checked(2)
		if is_item_checked(2):
			Globals.unmute = true
			if Globals.music_volume == 0:
				Globals.music_volume = 0.5
				AudioServer.set_bus_volume_linear(Globals.master_bus,Globals.music_volume)
				
		else:
			AudioServer.set_bus_volume_linear(Globals.master_bus,0)
			Globals.music_volume = 0
			Globals.unmute = false
		
