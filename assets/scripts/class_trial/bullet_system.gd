extends Control
@onready var bullets: Control = $"."
@onready var truth_bullet: TextureRect = $TruthBullet
@onready var shoot_anim: AnimationPlayer = $ShootAnim
@onready var big_gunshot: AudioStreamPlayer = $"../sfx/big_gunshot"
@onready var small_gunshot: AudioStreamPlayer = $"../sfx/small_gunshot"
@onready var noise_shoot_vfx: TextureRect = $crosshair/noise_shoot_vfx
@onready var noise_anim: AnimationPlayer = $"../crosshair/noise_shoot_vfx/noise_anim"
@onready var downtime: Timer = $downtime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func truth_shoot():
	if downtime.time_left > 0.0:
		return
	big_gunshot.play()
	shoot_anim.stop()
	shoot_anim.play("shoot")
	downtime.start(2.0)
func white_noise_shoot():
	noise_anim.stop()
	noise_anim.play("shoot")
	small_gunshot.play()


func _on_downtime_timeout() -> void:
	shoot_anim.play("reload")
