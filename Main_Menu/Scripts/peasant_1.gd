extends CharacterBody2D
class_name Peasant_1

@onready var animations: AnimatedSprite2D = $Animations
@onready var movement: NavigationAgent2D = $NavigationAgent2D

#speed for test player movement function
@export var speed: float = 50.0

func _ready():
	return
