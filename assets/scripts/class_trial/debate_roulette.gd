extends Control
@onready var crosshair: Control = $crosshair
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var shoot_anim: AnimationPlayer = $Bullets/ShootAnim
@onready var revolver: TextureRect = $revolver
@onready var hud: Control = $Hud
@onready var bullets_main: Control = $Bullets
@onready var camera_node: Node3D = $"../CameraNode"
@onready var timer_label = $Hud/timer_label
@onready var dialog_progress_bar: TextureProgressBar = $Hud/dialog_progress_bar
@onready var progress: Label = $Hud/progress
@onready var words: Control = $Words
@onready var class_trial_main: Node3D = $".."
@onready var dialog_data = null
@onready var char_data = JsonParse.load_json("characters/characters.json")
@onready var name_label: Label = $Hud/name_label
@onready var words_theme = preload("res://assets/ui/themes/class_trial_debate_words.tres")
@onready var ready_anim: AnimationPlayer = $"Ready?/anim"
@onready var anim: AnimationPlayer = $anim
@onready var speeds: Label = $Hud/speeds
@onready var canvas = $CanvasLayer
var state = "nothing"
var timer = 499.0
var state_timer = 0.0
var dialog_index: int = 0

func _ready() -> void:
	reset()

func start():
	state = "start"
	camera_node.debate_spin()
	ready_anim.play("start")
	visible = true
	
func _process(delta: float) -> void:
	var minutes = (timer) / 60
	var seconds = int(timer) % 60
	var milliseconds = int((timer - int(timer)) * 100)
	
	timer_label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	crosshair.position = get_local_mouse_position() - crosshair.size / 2
	if state == "invisible":
		visible = false
	if state == "debate":
		timer -= delta
		debate_process(delta)
	if state == "start":
		start_process(delta)
	if state == "bullet_preview":
		preview_process(delta)
			
	revolver.rotation += delta * 0.2
	
func start_process(delta): # PREVIEW PROCESS
	
	canvas.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	state_timer += delta
	if state_timer > 4.0:
		state_timer = 0.0
		bullets_main.reload()
		state = "bullet_preview"
		camera_node.state = ""
		
func debate_process(delta):
	state_timer += delta
	speeds.text = ""
	if hud.speed_state == "slow":
		speeds.text = "c o n c e n t r a t i n g . . ."
		state_timer -= delta * 0.5
	if hud.speed_state == "fast":
		speeds.text = "Speeding Up!"
		state_timer += delta * 1.8
	camera_node.fov(35)
	
	if state_timer > 5.0:
		debate_next()
		state_timer = 0
		
	if name_label.text == "name":
		debate_start()
		
func debate_start():
	camera_node._ready()
	debate_next(0)
	state = "debate"
	anim.play("start")
	
func debate_next(add=1):
	dialog_index = int(dialog_index + add) % dialog_data["dialog"].size()
	var character = dialog_data["dialog"][dialog_index]["character"]
	var char_data_one = char_data[character]
		
	words.word_init()
	
	name_label.operate(char_data_one["name"])
	dialog_progress_bar.value = (float(dialog_index) / float(dialog_data["dialog"].size() - 1)) * 100
	progress.text = str(dialog_index+1)+ "/" + str(dialog_data["dialog"].size())
	
	camera_node.position = Vector3(0,1.6,0)
	var podiums = get_tree().get_nodes_in_group("podium")
	for podium in podiums:
		if podium.char_name == character:
			podium.swap(char_data_one.sprites["neutral"])
			camera_node.focus_on(podium.face_center)
			return
	
func debate_camera_reset():
	camera_node.global_position = Vector3.ZERO
	camera_node.rotation = Vector3.ZERO
	state = "debate"
	state_timer = 0
	
func reset():
	state = "nothing"
	timer = 499.0
	state_timer = 0.0
	bullets_main.noise_anim.play("hide")
	anim.play("RESET")
	words.visible = true
	words._ready()
	crosshair.visible = true
	dialog_index = 0
	canvas.visible = false
	hud._ready()
	
func preview_process(delta):
	debate_start()
	
func finished():
	reset()
	class_trial_main.next_process()
	
func hide_self():
	anim.play("hide")
