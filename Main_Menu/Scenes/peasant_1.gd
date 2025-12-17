extends CharacterBody2D

var path_follow = PathFollow2D

func setup(new_path_follow: PathFollow2D):
	path_follow = new_path_follow
	
func _process(delta: float) -> void:
	path_follow.progress += 100*delta
	path_follow.rotate = false

func timer_end():
	print(rotation)
