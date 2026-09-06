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

var state = "bullet_preview"
var timer = 499.0
var state_timer = 0.0

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
	camera_node.play("RESET")
	camera_node.global_position = Vector3(0,0.5,0)
	camera_node.rotation = Vector3.ZERO
	progress.text = "0/" + str(dialog_data.size())
	
