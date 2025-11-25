extends PopupMenu

func _on_index_pressed(index: int) -> void:
	if index == 0:
		get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
