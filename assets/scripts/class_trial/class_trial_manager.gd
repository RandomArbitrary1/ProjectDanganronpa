extends Node3D
@onready var class_trial_ring: Node3D = $"../ClassTrialRing"
@onready var camera_3d: Node3D = $CameraNode
@onready var preparation: Control = $Preparation
@onready var debate_roulette: Control = $DebateRoulette
@onready var music: AudioStreamPlayer = $music/pre_music
@onready var music_2: AudioStreamPlayer = $music/music2
@onready var music_dialog: AudioStreamPlayer = $music_dialog
@onready var dialog: Control = $Dialog
@onready var intro: Control = $Intro

var state = "prepare"
var data = JsonParse.load_json("class_trial/debate/debate1.json")
var char_data = JsonParse.load_json("characters/characters.json")
var podiums = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	podiums = get_tree().get_nodes_in_group("podium")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "dialog":
		dialog_process(delta)
	if state == "prepare":
		prepare()
	if state == "debate":
		debate()
	if state == "dialog":
		if !dialog.active:
			state = "debate"

func prepare():
	if !preparation.state == "hide":
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
		music_dialog.stop()
	preparation.visible = false
	
func start_dialog():
	state = "dialog"
	music_dialog.play()
	music.stop()
	music_2.stop()
	dialog.start()
	camera_3d.fov(25)
func dialog_process(delta):
	var name_ch = dialog.nameplate.get_node("full_name").text
	var key = null
	for k in char_data:
		if char_data[k].name == name_ch:
			key = k
	for podium in podiums:
		if podium.char_name == key:
			camera_3d.look_at(podium.global_position, Vector3.UP)
			break
	
