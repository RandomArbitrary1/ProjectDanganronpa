extends Control
@onready var crosshair: TextureRect = $crosshair
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var hp: ProgressBar = $HP
@onready var concentrate: ProgressBar = $Concentrate
@onready var shoot_anim: AnimationPlayer = $Bullets/ShootAnim
@onready var revolver: TextureRect = $revolver
@onready var bullets: Control = $Bullets
@onready var camera_node: Node3D = $"../CameraNode"
@onready var timer_label = $timer_label
@onready var dialog_progress_bar: TextureProgressBar = $dialog_progress_bar
@onready var progress: Label = $progress
@onready var words: Control = $Words
@onready var class_trial_main: Node3D = $".."
@onready var dialog_data = class_trial_main.data["dialog"]
@onready var char_data = JsonParse.load_json("characters/characters.json")
@onready var name_label: Label = $name_label
@onready var words_theme = preload("res://assets/ui/themes/class_trial_debate_words.tres")
@onready var ready_anim: AnimationPlayer = $"Ready?/anim"
var state = "nothing"
var timer = 499.0
var state_timer = 0.0
var dialog_index: int = 0

func _ready() -> void:
	hp.value = 100
	concentrate.value = 100
	bullets.noise_anim.play("hide")

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
		bullets.white_noise_shoot()
	if Input.is_action_just_pressed("LMB"):
		bullets.truth_shoot()
	
func start_process(delta): # PREVIEW PROCESS
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	state_timer += delta
	if state_timer > 4.0:
		bullets.reload()
		state = "bullet_preview"
		camera_node.play("rotate_in_center")
		
func debate_process(delta):
	concentrate.value += delta * 8.3
	if Input.is_action_pressed("Spacebar"):
		concentrate.value -= delta * 35.0
		
	state_timer += delta
	camera_node.fov(35)
	if state_timer > 3.0:
		debate_next()
		state_timer = 0
	if name_label.text == "name":
		debate_start()
	words_process(delta)
		
func debate_start():
	debate_next(0)
	state = "debate"
	debate_camera_reset()
	
func debate_next(add=1):
	dialog_index = int(dialog_index + add) % dialog_data.size()
	var character = dialog_data[dialog_index]["character"]
	var char_data_one = char_data[character]
		
	word_init()
	
	name_label.text = str(char_data_one["name"])
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
			test_tween.parallel().tween_property(camera_node,"global_rotation",target_rotation,1.0)
			return
	print("ERROR, no character",character, "has been found!")
	
func debate_camera_reset():
	print("CAEMERA GOT RESET!!")
	camera_node.global_position = Vector3(0,1.8,0)
	camera_node.rotation = Vector3.ZERO
	state = "debate"
	state_timer = 0
	camera_node.play("RESET")
	
func word_init():
	for w in words.get_children():
		w.queue_free()
		
	var label = Label.new()
	label.text = str(dialog_data[dialog_index]["content"])
	label.theme = words_theme
	words.add_child(label)
	label.position = Vector2(625,464)
	label.pivot_offset = label.size / 2 # Offset works after add_child
	
func words_process(delta):
	for w in words.get_children():
		w.rotation += delta * 0.1
func preview_process(delta):
	debate_start()
