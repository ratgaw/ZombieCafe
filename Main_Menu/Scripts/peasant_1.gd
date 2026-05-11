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
@onready var chair_choice: Vector2i
@onready var ordered: bool = false
@onready var parent = get_parent()
@onready var tilepath
@onready var at_front
@onready var Front_ID
@onready var NPC_Instance
@onready var Front_Instance

#speed for test player movement function
@export var speed: float = 75.0

#Change description
func _ready():
	parent.order_made.connect(_order)
	if get_parent().map_sig == true:
		parent.line.append(get_instance_id())
		NPC_Instance = instance_from_id(get_instance_id())
		Front_ID = parent.line[parent.line.find(get_instance_id()) - 1]
		Front_Instance = instance_from_id(Front_ID)
		
		movepath = parent.orderpath
		tilepath = parent.cellpath
		at_front = parent.line.front()
		print(parent.line)
		movepath[1].x += 16
		movepath[1].y += 16
	else:
		return

#Finds the most efficient path for pathfinding, point path for movement and id path for collision management
func _pathfind(Start: Vector2i, End: Vector2i):
	movepath = Globals.astar_map.get_point_path(Start, End)
	tilepath = Globals.astar_map.get_id_path(Start, End)
	movepath[1].x += 16
	movepath[1].y += 16

#Function to move NPCs to their seats after ordering
func _order():
	if len(movepath) > 1 && ordered == false:
		return
	elif len(movepath) > 1 && ordered == true:
		return
	elif len(movepath) < 2 && ordered == false:
		parent.line.pop_front()
		if parent.chair_list.size() == 0:
			print("All seats are taken >:(")
		else:
			in_line = false
			randomize()
			chair_choice = parent.chair_list.pick_random()
			parent.chair_list.erase(chair_choice)
			_pathfind(Globals.order, chair_choice)
			ordered = true
	else:
		print(get_instance_id())
		parent.chair_list.append(chair_choice)
		queue_free()

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
	#Default for movepath issues to do nothing
	if movepath.is_empty():
		print("No movepath.")
	#NPC in line has 2 cases - they're not first in line, catch all for anything else
	elif in_line == true:
		if parent.line.front() != get_instance_id():
			if NPC_Instance.global_position.distance_to(Front_Instance.global_position) >= 20:
				in_line = false
			else:
				_play_animation(direction)
		else:
			_play_animation(direction)
	#NPC makes a movement, removing last spot moved to if close and handles collisions
	elif len(movepath) > 1:
		_movement(movepath[1])
		velocity = direction * speed
		_play_animation(direction)
		if distance < 1.5:
			movepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16
		var collision = move_and_collide(velocity * delta)
		#3 cases - in line NPC with in line NPC, in line NPC with out of line NPC, and all other collisions
		if collision:
			var NPC_ID = collision.get_collider_id()
			if NPC_ID == Front_ID && ordered == false:
				in_line = true
			elif NPC_ID not in parent.line && ordered == false:
				return
			else:
				var heavy_spot = tilepath[1]
				Globals.astar_map.set_point_weight_scale(heavy_spot, 100)
				Globals.astar_map.update()
				_pathfind(tilepath[0], chair_choice)
				Globals.astar_map.set_point_weight_scale(heavy_spot, 1)
				Globals.astar_map.update()
	#Handles only case left, NPC reaching end of movepath which action depends on if they've ordered or not
	else:
		direction = Vector2(0.0, 0.0)
		if ordered == false:
			in_line = true
		_play_animation(direction)
