extends Control
@onready var crosshair: TextureRect = $crosshair
@onready var big_gunshot: AudioStreamPlayer = $sfx/big_gunshot
@onready var small_gunshot: AudioStreamPlayer = $sfx/small_gunshot
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var noise_shoot_vfx: TextureRect = $crosshair/noise_shoot_vfx
@onready var noise_anim: AnimationPlayer = $crosshair/noise_shoot_vfx/noise_anim
@onready var hp: ProgressBar = $HP
@onready var concentrate: ProgressBar = $Concentrate
var state = "debate"
var timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp.value = 100
	concentrate.value = 100
	noise_anim.play("hide")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	crosshair.position = get_local_mouse_position() - crosshair.size / 2
	if state == "start":
		self.visible = false
		if timer > 1.0:
			self.visible = true
			state = "debate"
		else:
			timer += delta

func _input(event: InputEvent) -> void:
	if !self.visible:
		return
	if Input.is_action_just_pressed("RMB"):
		white_noise_shoot()
		
func white_noise_shoot():
	noise_anim.stop()
	noise_anim.play("shoot")
	small_gunshot.play()
