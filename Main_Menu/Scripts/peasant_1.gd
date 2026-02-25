extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movement: NavigationAgent2D = $NavigationAgent2D
@onready var pathfinding: Array

signal Order_Taken (Order_Taken : bool)
signal Order_Fulfilled (Order_Fufilled : bool)

#speed for test player movement function
@export var speed: float = 50.0


func _ready():
	if Globals.map_bounds == Rect2i():
		NpcPathfinding.find_map_bounds($"../../Floor Layer")
		NpcPathfinding.astar.region = Globals.map_bounds
		NpcPathfinding.find_map_obs($"../../Floor Layer", $"../../Floor Prop Layer", $"../../Wall Layer", $"../../Wall Ornament Layer", $"../../Ceiling Layer")
		NpcPathfinding.astar.update()
		print(Globals.obstacles_pos)
		setpath()
	else:
		setpath()

func _process(delta):
	if pathfinding.size() == 0:
		return
	elif NpcPathfinding.astar.is_point_solid(pathfinding.front()):
		setpath()
	else:
		print(pathfinding)
		var fmovement = pathfinding[0] * speed * delta
		pathfinding.remove_at(0)
		translate(fmovement)

func setpath():
	pathfinding = NpcPathfinding.astar.get_point_path(Globals.start_pos, Globals.order_pos, true)
