extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movepath: Array
@onready var parent = get_parent()
@onready var direction
@onready var distance
@onready var NPC_ID = get_instance_id()
@onready var speed : int = 50
@onready var chair_choice
@onready var tilepath: Array
@onready var last_animation: String = "Idle_Front"
@onready var last_dir: int = 0
@onready var cur_dir
@onready var waiting = false

#On NPC generation set beginning movepath to the orderpath made by the map, adjusted for center of tiles
func _ready():
	parent.order_made.connect(_order)
	parent.move_line.connect(parent._line_movement)
	parent.line.append(get_instance_id())
	movepath = parent.orderpath
	movepath[1].x += 16
	movepath[1].y += 16

func _physics_process(delta: float):
	#3 cases for NPCs waiting in the line - catching index overflow errors, NPCs turn to move, catch all no change
	if waiting == true:
		_play_animations(direction)
		if parent.pos >= len(parent.line):
			return
		if parent.line[parent.pos] == NPC_ID:
			waiting = false
		else:
			return
	#Actions if NPC is in line, but not the front of the line and isn't yet waiting
	elif NPC_ID in parent.line && len(movepath) > 1:
		_movement()
		velocity = speed * direction
		var collision = move_and_collide(velocity * delta)
		_play_animations(direction)
		#2 Cases for collision - NPC is in line, not in line catch all
		if collision:
			var col_ID = collision.get_collider_id()
			#If the NPC collides with the NPC in front of them in line, loop still until the line moves
			if NPC_ID in parent.line && parent.line.find(NPC_ID) == (parent.line.find(col_ID) + 1):
				waiting = true
			else:
				return
		if distance <= 5:
			movepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16
	#Actions if NPC has reached the end of their movepath
	elif len(movepath) < 2:
		if NPC_ID in parent.line:
			return
		else:
			return
	#Catch all for NPC movement as they move through their movepath
	else:
		_movement()
		velocity = speed * direction
		var collision = move_and_collide(velocity * delta)
		_play_animations(direction)
		#2 Cases for collision - NPC is in line, not in line catch all
		if collision:
			if NPC_ID in parent.line:
				return
			else:
				Globals.astar_map.set_point_weight_scale(tilepath[1], 100)
				var heavy_spot = tilepath[1]
				Globals.astar_map.update()
				_pathfind(tilepath[0], chair_choice)
				Globals.astar_map.set_point_weight_scale(heavy_spot, 1)
				Globals.astar_map.update()
		if distance <= 5:
			movepath.pop_front()
			tilepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16

#Calculates direction to next point then the distance to it, isolates movement in only 1 direction at a time
func _movement():
	direction = instance_from_id(NPC_ID).global_position.direction_to(movepath[1])
	if abs(direction.x) > abs(direction.y):
		direction.y = 0.0
	elif abs(direction.x) < abs(direction.y):
		direction.x = 0
	else:
		direction.y = 0
	distance = instance_from_id(NPC_ID).global_position.distance_to(movepath[1])

#Calculates path for NPCs as well as tile paths to use for collision handling
func _pathfind(Start: Vector2i, End: Vector2i):
	movepath = Globals.astar_map.get_point_path(Start, End)
	tilepath = Globals.astar_map.get_id_path(Start, End)

#4 Cases to react to order being called - NPC at front of line, NPC not at front of line, NPC ordered not seated,
#catch all else to deal with seated NPCs
func _order():
	if NPC_ID in parent.line && len(movepath) < 2:
		if len(parent.chair_list) > 0:
			randomize()
			chair_choice = parent.chair_list.pick_random()
			parent.line.erase(chair_choice)
			_pathfind(Globals.order, chair_choice)
			movepath[1].x += 16
			movepath[1].y += 16
			parent.line.remove_at(0)
			print("Activated")
			parent.move_line.emit()
		else:
			return
	elif NPC_ID in parent.line && len(movepath) > 1:
		return
	elif NPC_ID not in parent.line && len(movepath) > 1:
		return
	else:
		parent.chair_list.append(chair_choice)
		queue_free()

func _play_animations(adirection: Vector2):
	if abs(adirection.x) > abs(adirection.y):
		cur_dir = signi(adirection.x)
	else:
		cur_dir = signi(adirection.y) * 2
	#Animations if direction remains the same as the last call
	if cur_dir == last_dir:
		return
	#Animations if direction has changed since last call
	elif cur_dir != last_dir:
		animations.stop()
		match cur_dir:
			1:
				animations.play("Walk_Right")
			-1:
				animations.play("Walk_Left")
			0:
				#For cases where NPC is now stopped, but was moving before
				match last_dir:
					1:
						animations.play("Idle_Left")
					-1:
						animations.play("Idle_Right")
					2:
						animations.play("Idle_Front")
					-2:
						animations.play("Idle_Back")
					_:
						animations.play("Idle_Front")
			2:
				animations.play("Walk_Down")
			-2:
				animations.play("Walk_Up")
		last_dir = cur_dir
	#Catch all
	else:
		print("Weird Animations Error.")
