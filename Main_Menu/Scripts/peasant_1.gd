extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movepath: Array
@onready var direction
@onready var distance
@onready var trigger = false
@onready var max_speed


#speed for test player movement function
@export var speed: float = 100.0

func _ready():
	return

func _pathfind():
	movepath = Globals.astar_map.get_point_path(Vector2i(3, -7), Vector2i(-8,-3))
	print(movepath)

func _movement(next_pos : Vector2i):
	
	direction = global_transform.origin.direction_to(next_pos)
	distance = global_transform.origin.distance_to(next_pos)

func _physics_process(delta: float) -> void:
	if movepath.is_empty():
		return
	elif trigger == false:
		_pathfind()
		_movement(movepath[1])
		max_speed = (distance / delta)
		velocity = direction * minf(speed, max_speed)
		move_and_slide()
		trigger = true
	elif len(movepath) < 2:
		return
	else:
		_movement(movepath[1])
		velocity = direction * minf(speed, max_speed)
		move_and_slide()
		if distance < 1.5:
			movepath.pop_front()
