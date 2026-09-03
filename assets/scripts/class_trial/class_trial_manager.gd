extends Node3D
@onready var class_trial_ring: Node3D = $"../ClassTrialRing"
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var preparation: Control = $Preparation
@onready var debate_roulette: Control = $DebateRoulette
@onready var music: AudioStreamPlayer = $music/music
@onready var music_2: AudioStreamPlayer = $music/music2
var state = "prepare"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "prepare":
		prepare()
	if state == "debate":
		debate()

func prepare():
	if !music.playing:
		music.play()
		music_2.stop()
	debate_roulette.visible = false
	preparation.visible = true
	
func debate():
	if !music_2.playing:
		debate_roulette.state = "start"
		music_2.play()
		music.stop()
	preparation.visible = false
