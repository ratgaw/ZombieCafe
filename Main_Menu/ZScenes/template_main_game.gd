extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

#checks for esc key press to pull up options menu
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Menu Pull Up"):
		$PopupMenu.popup(Rect2i(0,0,300,500))
