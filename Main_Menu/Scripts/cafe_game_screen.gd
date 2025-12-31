extends Node2D

@onready var game_options_menu: PopupMenu = $"Game Options Menu"
@onready var peasant_scene = preload("res://Scenes/peasant_1.tscn")

func _ready() -> void:
	pass

#Activates popup options menu
func _input(menu_popup: InputEvent) -> void:
	if menu_popup.is_action_pressed("options_menu"):
		game_options_menu.popup(Rect2i(0,0,300,100))
