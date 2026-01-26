extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movement: NavigationAgent2D = $NavigationAgent2D
signal Order_Taken (Order_Taken : bool)
signal Order_Fulfilled (Order_Fufilled : bool)

#speed for test player movement function
@export var speed: float = 50.0

func _ready():
	set_move_to_target(Globals.order_pos)

func _process(delta):
	_movement(delta)

func _movement(delta):
	
	if movement.is_navigation_finished():
		return
	var mov_pos = movement.get_next_path_position()
	var mov_dir = global_position.direction_to(mov_pos)
	var smovement = mov_dir * speed * delta
	
	if smovement.x < 0 && smovement.x < smovement.y:
		animations.animation = "Walk_Left"
	elif mov_dir.x > 0 && smovement.x > smovement.y:
		animations.animation = "Walk_Right"
	elif mov_dir.y < 0 && smovement.y < smovement.x:
		animations.animation = "Walk_Up"
	elif mov_dir.y > 0 && smovement.y > smovement.x:
		animations.animation = "Walk_Down"
	
	translate(smovement)

func set_move_to_target(target : Vector2):
	movement.target_position = target
