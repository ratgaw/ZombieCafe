extends PopupMenu

#Controls Game Options Menu options 
func _on_index_pressed(index: int) -> void:
	if index == 0:
		#Takes user back to main menu
		get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
	if index == 1:
		#Takes user to options menu
		Globals.last_scene = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file("res://Scenes/Settings Menu.tscn")
		
