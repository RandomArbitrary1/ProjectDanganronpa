extends Control
@onready var crosshair: TextureRect = $crosshair
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var hp: ProgressBar = $HP
@onready var concentrate: ProgressBar = $Concentrate
@onready var shoot_anim: AnimationPlayer = $Bullets/ShootAnim
@onready var revolver: TextureRect = $revolver
@onready var bullets: Control = $Bullets
@onready var camera_node: Node3D = $"../../ClassTrialCamera"

var state = "debate"
var timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp.value = 100
	concentrate.value = 100
	bullets.noise_anim.play("hide")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Spacebar"):
		concentrate.value -= delta * 25.0
	else:
		concentrate.value += delta * 8.3
		
	if self.visible:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	crosshair.position = get_local_mouse_position() - crosshair.size / 2
	
	if state == "start":
		self.visible = false
		if timer > 4.0:
			if !self.visible:
				state = "debate"
				camera_node.play("rotate_in_center")
				self.visible = true
		else:
			timer += delta
			
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
	bullets.reload()
