extends Control
@onready var crosshair: TextureRect = $crosshair
@onready var big_gunshot: AudioStreamPlayer = $sfx/big_gunshot
@onready var small_gunshot: AudioStreamPlayer = $sfx/small_gunshot
@onready var break_sfx: AudioStreamPlayer = $sfx/break
@onready var noise_shoot_vfx: TextureRect = $crosshair/noise_shoot_vfx
@onready var noise_anim: AnimationPlayer = $crosshair/noise_shoot_vfx/noise_anim
@onready var hp: ProgressBar = $HP
@onready var concentrate: ProgressBar = $Concentrate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp.value = 100
	concentrate.value = 100
	noise_anim.play("hide")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	crosshair.position = get_local_mouse_position() - crosshair.size / 2

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("RMB"):
		white_noise_shoot()
		
func white_noise_shoot():
	noise_anim.stop()
	noise_anim.play("shoot")
	small_gunshot.play()
