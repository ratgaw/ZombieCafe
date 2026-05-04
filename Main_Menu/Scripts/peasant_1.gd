extends CharacterBody2D
class_name Peasant_1

@onready var peasant_1: Peasant_1 = $"."
@onready var animations: AnimatedSprite2D = $Animations
@onready var movepath: Array
@onready var direction
@onready var distance
@onready var max_speed
@onready var last_direction
@onready var cur_animation = "Idle_Front"
@onready var in_line: bool = false
@onready var last_bump
@onready var parent = get_parent()

#speed for test player movement function
@export var speed: float = 75.0

func _ready():
	parent.order_made.connect(_order)
	if get_parent().map_sig == true:
		_pathfind()
	else:
		return

#Helper function used to calculate NPC path
func _pathfind():
	movepath = Globals.astar_map.get_point_path(Globals.entrance, Globals.order)
	movepath[1].x += 16
	movepath[1].y += 16

#Test function to get rid of NPC after ordering
func _order():
	if len(movepath) < 2:
		print("VVVVVV")
		print("NPC: ", peasant_1.get_instance_id(), " removed.")
		queue_free()
	else:
		print("------")
		print("NPC: ", peasant_1.get_instance_id(), " - In line status: ", in_line)

#Helper function used to find direction and distance to next point in pathfinding list
func _movement(next_pos : Vector2i):
	direction = global_transform.origin.direction_to(next_pos)
	distance = global_transform.origin.distance_to(next_pos)

#Controls movement animation of peasant based on direction
func _play_animation(adirection : Vector2):
	#Handles animiations for waiting in line
	if in_line == true:
		match cur_animation:
			"Walk_Left":
				animations.stop()
				animations.play("Idle_Left")
				cur_animation = "Idle_left"
			"Walk_Right":
				animations.stop()
				animations.play("Idle_Right")
				cur_animation = "Idle_Right"
			"Walk_Down":
				animations.stop()
				animations.play("Idle_Front")
				cur_animation = "Idle_Front"
			"Walk_Up":
				animations.stop()
				animations.play("Idle_Back")
				cur_animation = "Idle_Back"
			_:
				return
				
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
# plays movement animation, handles collision with other NPCS, and stops moving once path end is reached
func _physics_process(delta: float) -> void:
	if movepath.is_empty():
		return
	elif in_line == true:
		_play_animation(direction)
		if is_instance_valid(last_bump) == false:
			in_line = false
		elif peasant_1.global_position.distance_to(last_bump.global_position) >= 20:
			in_line = false
	elif len(movepath) < 2:
		direction = Vector2(0.0, 0.0)
		_play_animation(direction)
		in_line = true
	else:
		_movement(movepath[1])
		velocity = direction * speed
		_play_animation(direction)
		var collision = move_and_collide(velocity * delta)
		if collision:
			var NPC_ID = collision.get_collider_id()
			NPC_ID = instance_from_id(NPC_ID)
			if NPC_ID.in_line == true:
				in_line = true
				last_bump = NPC_ID
		if distance < 1.5:
			movepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16
