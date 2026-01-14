extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
signal Order_Taken (Order_Taken : bool)
signal Order_Fulfilled (Order_Fufilled : bool)

#speed for test player movement function
@export var speed: float = 100.0

#function controlling player test movement & walk/idle animations
func _physics_process(_float):
	var direction := Vector2.ZERO

#Moves/plays walk animation on peasant depending on keystroke
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		$Animations.animation = "Walk_Down"
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		$Animations.animation = "Walk_Up"
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		$Animations.animation = "Walk_Left"
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		$Animations.animation = "Walk_Right"
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
	velocity = direction * speed
	move_and_slide()

#Returns peasant to idle animation depending on last direction moved
	if Input.is_action_just_released("move_down"):
		$Animations.animation = "Idle_Front"
	if Input.is_action_just_released("move_up"):
		$Animations.animation = "Idle_Back"
	if Input.is_action_just_released("move_left"):
		$Animations.animation = "Idle_Left"
	if Input.is_action_just_released("move_right"):
		$Animations.animation = "Idle_Right"
