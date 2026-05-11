extends CharacterBody2D
class_name Peasant_1

@onready var movepath: Array
@onready var parent = get_parent()
@onready var direction
@onready var distance
@onready var NPC_ID = get_instance_id()
@onready var speed : int = 50
@onready var a

#On NPC generation set beginning movepath to the orderpath made by the map, adjusted for center of tiles
func _ready():
	movepath = parent.orderpath
	movepath[1].x += 16
	movepath[1].y += 16

func _physics_process(delta: float):
	#Actions if NPC is in line
	if a == true:
		return
	#Actions if NPC has reached the end of their movepath
	elif len(movepath) < 2:
		return
	#Catch all for NPC movement as they move through their movepath
	else:
		_movement()
		velocity = speed * direction
		var collision = move_and_collide(velocity * delta)
		if collision:
			a = true
		if distance <= 5:
			movepath.pop_front()
			if len(movepath) > 1:
				movepath[1].x += 16
				movepath[1].y += 16

func _movement():
	direction = instance_from_id(NPC_ID).global_position.direction_to(movepath[1])
	distance = instance_from_id(NPC_ID).global_position.distance_to(movepath[1])
