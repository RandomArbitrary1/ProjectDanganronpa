extends Control

@export var scene: String = "res://scenes/class_trial/trial_ground.tscn"

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var rotating_loading_obj: TextureRect = $RotatingLoadingObj
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var progress = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("appear")
	ResourceLoader.load_threaded_request(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotating_loading_obj.rotation += delta * 0.9
	
	var status = ResourceLoader.load_threaded_get_status(scene, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var percent = progress[0] * 100
			progress_bar.value = percent
		ResourceLoader.THREAD_LOAD_LOADED:
			var fin_scene = ResourceLoader.load_threaded_get(scene)
			get_tree().change_scene_to_packed(fin_scene)
