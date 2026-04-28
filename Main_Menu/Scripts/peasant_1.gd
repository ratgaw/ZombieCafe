extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movepath: Array
@onready var direction
@onready var distance
@onready var trigger = false
@onready var max_speed
@onready var last_direction
@onready var cur_animation


#speed for test player movement function
@export var speed: float = 75.0

func _ready():
	return

#Helper function used to calculate NPC path
func _pathfind():
	movepath = Globals.astar_map.get_point_path(Vector2i(3, -7), Vector2i(-8,-3))

#Helper function used to find direction and distance to next point in pathfinding list
func _movement(next_pos : Vector2i):
	direction = global_transform.origin.direction_to(next_pos)
	distance = global_transform.origin.distance_to(next_pos)

#Controls walking animation of peasant based on direction
func _play_animation(adirection : Vector2):
	if last_direction == null:
		last_direction = adirection
		if abs(adirection.x) > abs(adirection.y):
			match sign(adirection.x):
				-1.0:
					animations.stop()
					animations.play("Walk_Left")
					cur_animation = "Walk_Left"
				1.0:
					animations.stop()
					animations.play("Walk_Right")
					cur_animation = "Walk_Right"
				0.0:
					push_error("X direction cannot equal direction y for this animation argument to prompt.")
		elif abs(adirection.x) <= abs(adirection.y):
			match sign(adirection.y):
				-1.0:
					animations.stop()
					animations.play("Walk_Up")
					cur_animation = "Walk_Up"
				1.0:
					animations.stop()
					animations.play("Walk_Down")
					cur_animation = "Walk_Down"
				0.0:
					animations.stop()
					match cur_animation:
						"Walk_Left":
							animations.play("Idle_Left")
						"Walk_Right":
							animations.play("Idle_Right")
						"Walk_Down":
							animations.play("Idle_Front")
						"Walk_Up":
							animations.play("Idle_Back")
	elif last_direction.is_equal_approx(adirection):
		return
	else:
		last_direction = adirection
		if abs(adirection.x) > abs(adirection.y):
			match sign(adirection.x):
				-1.0:
					animations.stop()
					animations.play("Walk_Left")
					cur_animation = "Walk_Left"
				1.0:
					animations.stop()
					animations.play("Walk_Right")
					cur_animation = "Walk_Right"
				0.0:
					push_error("X direction cannot equal direction y for this animation argument to prompt.")
		elif abs(adirection.x) <= abs(adirection.y):
			match sign(adirection.y):
				-1.0:
					animations.stop()
					animations.play("Walk_Up")
					cur_animation = "Walk_Up"
				1.0:
					animations.stop()
					animations.play("Walk_Down")
					cur_animation = "Walk_Down"
				0.0:
					animations.stop()
					match cur_animation:
						"Walk_Left":
							animations.play("Idle_Left")
						"Walk_Right":
							animations.play("Idle_Right")
						"Walk_Down":
							animations.play("Idle_Front")
						"Walk_Up":
							animations.play("Idle_Back")

#Controls NPC movement, not doing anything until a pathfinding path is populated, 
# then calculating most efficient path once and moves, playing movement animation,
# stops moving once path end is reached
func _physics_process(delta: float) -> void:
	if movepath.is_empty():
		return
	elif trigger == false:
		_pathfind()
		movepath[1].x += 16
		movepath[1].y += 16
		_movement(movepath[1])
		max_speed = (distance / delta)
		velocity = direction * minf(speed, max_speed)
		_play_animation(direction)
		move_and_slide()
		trigger = true
	elif len(movepath) < 2:
		direction = Vector2(0.0, 0.0)
		_play_animation(direction)
	else:
		_movement(movepath[1])
		velocity = direction * minf(speed, max_speed)
		_play_animation(direction)
		move_and_slide()
		if distance < 1.5:
			movepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16
