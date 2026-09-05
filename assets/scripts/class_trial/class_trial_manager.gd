extends Node3D
@onready var class_trial_ring: Node3D = $"../ClassTrialRing"
@onready var camera_3d: Node3D = $"../ClassTrialCamera"
@onready var preparation: Control = $Preparation
@onready var debate_roulette: Control = $DebateRoulette
@onready var music: AudioStreamPlayer = $music/music
@onready var music_2: AudioStreamPlayer = $music/music2

var state = "prepare"
var data = JsonParse.load_json("class_trial/debate/debate1")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state == "prepare":
		prepare()
	if state == "debate":
		debate()

func prepare():
	camera_3d.global_position = Vector3(0,7.5,15)
	camera_3d.rotation.x = -0.4
	if !music.playing:
		music.play()
		music_2.stop()
	debate_roulette.visible = false
	preparation.visible = true
	
func debate():
	if !music_2.playing:
		debate_roulette.start()
		music_2.play()
		music.stop()
	preparation.visible = false
