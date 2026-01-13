extends CharacterBody2D
class_name Peasant_1

signal Order_Taken (Order_Taken : bool)
signal Order_Fulfilled (Order_Fufilled : bool)

#speed for test player movement function
@export var speed: float = 200.0

#function controlling player test movement
func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("move_down"):
		direction.y += 0.75
	if Input.is_action_pressed("move_up"):
		direction.y -= 0.75
	if Input.is_action_pressed("move_left"):
		direction.x -= 0.75
	if Input.is_action_pressed("move_right"):
		direction.x += 0.75
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
	velocity = direction * speed
	
	move_and_slide()
