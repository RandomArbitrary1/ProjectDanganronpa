extends Node3D
@onready var class_trial_ring: Node3D = $"../ClassTrialRing"
@onready var camera_3d: Node3D = $CameraNode
@onready var preparation: Control = $Preparation
@onready var debate_roulette: Control = $DebateRoulette
@onready var music: AudioStreamPlayer = $music/pre_music
@onready var dialog: Control = $Dialog
@onready var intro: Control = $Intro

var state = "prepare"
var structure = JsonParse.load_json("class_trial/structure/trial1.json")
var char_data = JsonParse.load_json("characters/characters.json")
var structure_line = 0
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
			next_process()

func prepare():
	if !preparation.state == "hide":
		camera_3d.global_position = Vector3(0,7.5,15)
		camera_3d.rotation.x = -0.4
	if !music.playing:
		music.play()
	debate_roulette.visible = false
	preparation.visible = true
	
func debate():
	if !debate_roulette.visible:
		debate_roulette.visible = true
		debate_roulette.start()
		music.stop()
	preparation.visible = false
	
func next_process(next=1):
	music.stop()
	camera_3d.fov(25)
	structure_line = structure_line + next
	var path = structure[structure_line]
	var type = path.get_base_dir().get_file()
	var json = path.trim_prefix("res://assets/data/")
	if type == "dialog":
		state = "dialog"
		dialog.file = load(path)
		dialog.start()
	if type == "debate":
		state = "debate"
		debate_roulette.dialog_data = JsonParse.load_json(json)
		
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
	
