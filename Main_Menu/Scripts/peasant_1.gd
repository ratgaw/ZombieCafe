extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movepath: Array
@onready var movement

#speed for test player movement function
@export var speed: float = 50.0

func _ready():
	return

func _pathfind():
	movepath = Globals.astar_map.get_id_path(Vector2i(3, -7), Vector2i(-8,-3))
	print(movepath)

func _movement(cur_pos : Vector2i, next_pos : Vector2i):
	var x_direction: int
	var y_direction: int
	var xmax = max(cur_pos.x, next_pos.x)
	var ymax = max(cur_pos.y, next_pos.y)
	if xmax == cur_pos.x:
		x_direction = -1
	elif xmax == next_pos.x:
		x_direction = 1
	else:
		x_direction = 0
	if ymax == cur_pos.y:
		y_direction = -1
	elif ymax == next_pos.y:
		y_direction = 1
	else:
		y_direction = 0
	var direction = Vector2i(x_direction, y_direction)
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if movepath.is_empty():
		return
	else:
		move_and_slide()
