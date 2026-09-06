extends Control
@onready var crosshair: TextureRect = $crosshair
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var hp: ProgressBar = $HP
@onready var concentrate: ProgressBar = $Concentrate
@onready var shoot_anim: AnimationPlayer = $Bullets/ShootAnim
@onready var revolver: TextureRect = $revolver
@onready var bullets: Control = $Bullets
@onready var camera_node: Node3D = $"../../ClassTrialCamera"
@onready var timer_label = $timer_label
@onready var progress: Label = $progress
@onready var class_trial_main: Node3D = $".."
@onready var dialog_data = class_trial_main.data["dialog"]
@onready var char_data = JsonParse.load_json("characters/characters")
@onready var name_label: Label = $name_label
var state = "bullet_preview"
var timer = 499.0
var state_timer = 0.0
var dialog_index = 0

func _ready() -> void:
	hp.value = 100
	concentrate.value = 100
	bullets.noise_anim.play("hide")

func _process(delta: float) -> void:
	if Input.is_action_pressed("Spacebar"):
		concentrate.value -= delta * 25.0
	else:
		concentrate.value += delta * 8.3
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
			
	revolver.rotation += delta * 0.2

func _input(_event: InputEvent) -> void:
	if !self.visible:
		return
	if Input.is_action_just_pressed("RMB"):
		bullets.white_noise_shoot()
	if Input.is_action_just_pressed("LMB"):
		bullets.truth_shoot()
		
func start():
	state = "start"
	camera_node.play("intro1")
	
func start_process(delta):
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	self.visible = false
	if state_timer > 4.0:
		if !self.visible:
			bullets.reload()
			state = "bullet_preview"
			camera_node.play("rotate_in_center")
			self.visible = true
	else:
		state_timer += delta
		
func debate_process(delta):
	state_timer += delta
	camera_node.fov(35)
	if state_timer > 3.0:
		debate_next(delta)
		state_timer = 0
	if name_label.text == "name":
		debate_start(delta)
		
func debate_start(delta):
	debate_next(delta, 0)
	
func debate_next(_delta, add=1):
	dialog_index = (dialog_index + add) % dialog_data.size()
	var character = dialog_data[dialog_index]["character"]
	var char_data_one = char_data[character]
	
	print(char_data_one["name"],": ", dialog_data[dialog_index]["content"])
	name_label.text = str(char_data_one["name"])
	progress.text = str(dialog_index+1)+ "/" + str(dialog_data.size())
	
	var podiums = get_tree().get_nodes_in_group("podium")
	for podium in podiums:
		if podium.char_name == character:
			podium.expression(dialog_data[dialog_index]["expression"])
			var test_tween = create_tween()
			var target_position = podium.global_position - podium.global_transform.basis.z * 2.0
			#test_tween..parallel().tween_property(camera_node,"global_position",target_position,3.0)
			var target_rotation = camera_node.global_transform.looking_at(
			podium.global_position,
			Vector3.UP
		).basis.get_euler()
			test_tween.parallel().tween_property(camera_node,"global_rotation",target_rotation,1.0)
			return
	print("ERROR, no character",character, "has been found!")
func debate_camera_reset():
	camera_node.global_position = Vector3(0,1.8,0)
	camera_node.rotation = Vector3.ZERO
	state = "debate"
	state_timer = 0
	camera_node.play("RESET")
