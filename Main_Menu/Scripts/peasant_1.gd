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

##function controlling player test movement & walk/idle animations
#func _physics_process(_float):
	#var direction := Vector2.ZERO
#
##Moves/plays walk animation on peasant depending on keystroke
	#if Input.is_action_pressed("move_down"):
		#direction.y += 1
		#$Animations.animation = "Walk_Down"
	#if Input.is_action_pressed("move_up"):
		#direction.y -= 1
		#$Animations.animation = "Walk_Up"
	#if Input.is_action_pressed("move_left"):
		#direction.x -= 1
		#$Animations.animation = "Walk_Left"
	#if Input.is_action_pressed("move_right"):
		#direction.x += 1
		#$Animations.animation = "Walk_Right"
	#if direction != Vector2.ZERO:
		#direction = direction.normalized()
		#
	#velocity = direction * speed
	#move_and_slide()

##Returns peasant to idle animation depending on last direction moved
	#if Input.is_action_just_released("move_down"):
		#$Animations.animation = "Idle_Front"
	#if Input.is_action_just_released("move_up"):
		#$Animations.animation = "Idle_Back"
	#if Input.is_action_just_released("move_left"):
		#$Animations.animation = "Idle_Left"
	#if Input.is_action_just_released("move_right"):
		#$Animations.animation = "Idle_Right"

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
	
	print(smovement)
	translate(smovement)

func set_move_to_target(target : Vector2):
	movement.target_position = target
