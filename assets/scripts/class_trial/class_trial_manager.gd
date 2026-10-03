extends Node3D
@onready var class_trial_ring: Node3D = $"../ClassTrialRing"
@onready var camera_3d: Node3D = $CameraNode
@onready var preparation: Control = $Preparation
@onready var debate_roulette: Control = $DebateRoulette
@onready var music: AudioStreamPlayer = $music/pre_music
@onready var dialog: Control = $Dialog
@onready var intro: Control = $Intro
# TODO DANILO: Camera spins before entering big spin. ALL Hardcoded, no anim players.
# should anim players be used? only in dialog, not in debate.
var state = "prepare"
var structure = JsonParse.load_json("class_trial/structure/trial1.json")
var char_data = JsonParse.load_json("characters/characters.json")
var structure_line = 0
var podiums = null
var angle := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	podiums = get_tree().get_nodes_in_group("podium")
	#instant_begin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "prepare":
		prepare(delta)
	if state == "debate":
		debate()
	if state == "dialog":
		dialog_process(delta)
		if !dialog.active:
			next_process()

func prepare(delta):
	if !preparation.state == "hide":
		var radius := 3.0
		var height := 1.0
		var center = Vector3(0,2,0)
		angle += delta * 0.1
		camera_3d.global_position = center + Vector3(
		sin(angle) * radius, 
		height,
		cos(angle) * radius)
		camera_3d.look_at(center)
	if !music.playing:
		music.play()
	debate_roulette.visible = false
	preparation.visible = true
	
func debate():
	if debate_roulette.state == "nothing":
		debate_roulette.visible = true
		debate_roulette.state = "something"
		debate_roulette.start()
		music.stop()
	
	preparation.visible = false
	
func next_process(next=1):
	state = "nothing"
	music.stop()
	structure_line = structure_line + next
	var path = structure[structure_line]
	var type = path.get_base_dir().get_file()
	var json = path.trim_prefix("res://assets/data/")
	if type == "dialog":
		state = "dialog"
		dialog.file = load(path)
		dialog.start()
	if type == "debate":
		debate_roulette.start()
		debate_roulette.dialog_data = JsonParse.load_json(json)
		
func dialog_process(delta):
	var dialog_fullname_txt = dialog.nameplate.get_node("full_name").text
	camera_3d.fov(35)
	camera_3d.position = Vector3(0,1.3,0)
	
	var char_key = null
	for char in char_data: # Checks every character for their "shion" key name
		if char_data[char].name == dialog_fullname_txt: # If full name is equal to speaker
			char_key = char # get character KEY name
			break
	for podium in podiums:
		if podium.char_name == char_key:
			camera_3d.look_at(podium.face_center)
			break
	
func instant_begin():
	intro.start()
	intro.hide_elements()
	
func start(): # IS CALLED AFTER INTRO ANIMATION
	next_process(0)
