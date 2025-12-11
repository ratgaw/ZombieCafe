extends Control

const main_game_path = "res://Scenes/cafe_game.tscn"

var loading_status : int
var progress : Array[float]

@onready var loading_bar : ProgressBar = $"Loading Progress"

func _ready() -> void:
	ResourceLoader.load_threaded_request(main_game_path)

func _process(delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(main_game_path, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loading_bar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_game_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error. Could not load resource.")
