extends Control
@onready var crosshair: TextureRect = $crosshair
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var hp = $Hud/HP
@onready var concentrate = $Hud/Concentrate
@onready var shoot_anim: AnimationPlayer = $Bullets/ShootAnim
@onready var revolver: TextureRect = $revolver
@onready var bullets_main: Control = $Bullets
@onready var camera_node: Node3D = $"../CameraNode"
@onready var timer_label = $Hud/timer_label
@onready var dialog_progress_bar: TextureProgressBar = $Hud/dialog_progress_bar
@onready var progress: Label = $Hud/progress
@onready var words: Control = $Words
@onready var class_trial_main: Node3D = $".."
@onready var dialog_data = class_trial_main.data["dialog"]
@onready var char_data = JsonParse.load_json("characters/characters.json")
@onready var name_label: Label = $Hud/name_label
@onready var words_theme = preload("res://assets/ui/themes/class_trial_debate_words.tres")
@onready var ready_anim: AnimationPlayer = $"Ready?/anim"
@onready var anim: AnimationPlayer = $anim
var state = "nothing"
var timer = 499.0
var state_timer = 0.0
var dialog_index: int = 0

func _ready() -> void:
	hp.value = 100
	concentrate.value = 100
	bullets_main.noise_anim.play("hide")
	anim.play("RESET")

func start():
	state = "start"
	camera_node.play("intro1")
	ready_anim.play("start")
	
func _process(delta: float) -> void:
	timer -= delta
	
	var minutes = (timer) / 60
	var seconds = int(timer) % 60
	var milliseconds = int((timer - int(timer)) * 100)
	
	timer_label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	crosshair.position = get_local_mouse_position() - crosshair.size / 2
	
	if state == "debate":
		debate_process(delta)
	if state == "start":
		start_process(delta)
	if state == "bullet_preview":
		preview_process(delta)
			
	revolver.rotation += delta * 0.2

func _input(_event: InputEvent) -> void:
	if !state == "debate":
		return
	if Input.is_action_just_pressed("RMB"):
		bullets_main.white_noise_shoot()
	if Input.is_action_just_pressed("LMB"):
		bullets_main.truth_shoot()
	
func start_process(delta): # PREVIEW PROCESS
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	state_timer += delta
	if state_timer > 4.0:
		bullets_main.reload()
		state = "bullet_preview"
		camera_node.play("rotate_in_center")
		
func debate_process(delta):
	state_timer += delta
	concentrate.value += delta * 1.3
	
	if Input.is_action_pressed("Spacebar"):
		concentrate.value -= delta * 35.0
		state_timer -= delta * 0.5
		
	if Input.is_action_pressed("Ctrl"):
		state_timer += delta
		
	camera_node.fov(35)
	
	if state_timer > 5.0:
		debate_next()
		state_timer = 0
	if name_label.text == "name":
		debate_start()
		
func debate_start():
	debate_next(0)
	state = "debate"
	debate_camera_reset()
	anim.play("start")
	
func debate_next(add=1):
	dialog_index = int(dialog_index + add) % dialog_data.size()
	var character = dialog_data[dialog_index]["character"]
	var char_data_one = char_data[character]
		
	words.word_init()
	
	name_label.operate(char_data_one["name"])
	dialog_progress_bar.value = (float(dialog_index) / float(dialog_data.size() - 1)) * 100
	progress.text = str(dialog_index+1)+ "/" + str(dialog_data.size())
	
	var podiums = get_tree().get_nodes_in_group("podium")
	for podium in podiums:
		if podium.char_name == character:
			podium.swap(char_data_one.sprites["neutral"])
			var test_tween = create_tween()

			#test_tween..parallel().tween_property(camera_node,"global_position",target_position,3.0)
			var target_rotation = camera_node.global_transform.looking_at(
			podium.global_position,
			Vector3.UP
		).basis.get_euler()
			test_tween.parallel().tween_property(camera_node,"global_rotation",target_rotation,0.7)
			return
	print("ERROR, no character",character, "has been found!")
	
func debate_camera_reset():
	print("CAEMERA GOT RESET!!")
	camera_node.global_position = Vector3(0,1.8,0)
	camera_node.rotation = Vector3.ZERO
	state = "debate"
	state_timer = 0
	camera_node.play("RESET")

	
func preview_process(delta):
	debate_start()
