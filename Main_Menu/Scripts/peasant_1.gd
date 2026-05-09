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
@onready var NPC_in_front
@onready var chair_choice: Vector2i
@onready var ordered: bool = false
@onready var parent = get_parent()
@onready var tilepath
@onready var line_place

#speed for test player movement function
@export var speed: float = 75.0

#On NPC start connects to the order signal from the parent scene, then checks if parent scene has generated map
# before executing the pathfinding function
func _ready():
	parent.order_made.connect(_order)
	if get_parent().map_sig == true:
		parent.line.append(get_instance_id())
		line_place = len(parent.line - 1)
		_pathfind(Globals.entrance, Globals.order)
	else:
		return

#Function used to calculate NPC path given a start and end point
func _pathfind(Start: Vector2i, End: Vector2i):
	movepath = Globals.astar_map.get_point_path(Start, End)
	tilepath = Globals.astar_map.get_id_path(Start, End)
	movepath[1].x += 16
	movepath[1].y += 16

#Function to move NPCs to their seats after ordering
func _order():
	#After NPC finds a seat, make their seat available to chair list and despawn
	in_line = false
	if ordered == true && len(movepath) < 2:
		parent.chair_list.append(chair_choice)
		queue_free()
	#NPC at front of line removes self from line list, despawns if no seats are available, or selects random seat
	elif ordered == false && len(movepath) < 2:
		parent.line.pop_front()
		if parent.chair_list.size() == 0:
			print("All seats are taken >:(")
			queue_free()
		else:
			randomize()
			var chair = randi() % parent.chair_list.size()
			chair_choice = parent.chair_list[chair]
			parent.chair_list.erase(chair_choice)
			ordered = true
			_pathfind(Globals.order, chair_choice)
	else:
		return

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
	#Different actions when in line
	elif in_line == true:
		_play_animation(direction)
		if peasant_1.global_position.distance_to(instance_from_id(parent.line[line_place - 1]).global_position) >= 50:
			line_place -= 1
			in_line = false
	#If NPC reaches end of path, stand still and signal in_line
	elif len(movepath) < 2:
		direction = Vector2(0.0, 0.0)
		_play_animation(direction)
		in_line = true
	#NPC moves along path and handles collisions
	else:
		_movement(movepath[1])
		velocity = direction * speed
		_play_animation(direction)
		var collision = move_and_collide(velocity * delta)
		if collision:
			var NPC_ID = collision.get_collider_id()
			if parent.line.has(NPC_ID):
				return
			var NPC_instance = instance_from_id(NPC_ID)
			last_bump = NPC_instance
			if NPC_instance.in_line == true && ordered == false:
				if NPC_in_front == null:
					NPC_in_front = NPC_instance
				in_line = true
			elif ordered == true:
				Globals.astar_map.set_point_weight_scale(tilepath[1], 100)
				Globals.astar_map.update()
				_pathfind(tilepath[0], chair_choice)
				Globals.astar_map.set_point_weight_scale(tilepath[1], 1)
				Globals.astar_map.update()
		if distance < 1.5:
			movepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16
