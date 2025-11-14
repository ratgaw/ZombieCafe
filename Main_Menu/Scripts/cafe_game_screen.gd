extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"

func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
