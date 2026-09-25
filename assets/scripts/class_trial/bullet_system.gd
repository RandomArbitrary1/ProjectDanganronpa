extends Control
@onready var root: Control = $"."
@onready var truth_bullet: TextureRect = $TruthBullet
@onready var shoot_anim: AnimationPlayer = $ShootAnim
@onready var big_gunshot: AudioStreamPlayer = $"../sfx/big_gunshot"
@onready var small_gunshot: AudioStreamPlayer = $"../sfx/small_gunshot"
@onready var noise_anim: AnimationPlayer = $"../crosshair/noise_shoot_vfx/noise_anim"
@onready var crosshair_anim: AnimationPlayer = $"../crosshair/crosshair_anim"
@onready var downtime: Timer = $downtime
@onready var camera: Node3D = $"../../CameraNode"
@onready var debate_root: Control = $".."
@onready var crosshair: TextureRect = $"../crosshair"
@onready var time_lose: AudioStreamPlayer = $"../sfx/time_lose"
@onready var fired_bullet: RichTextLabel = $FiredBullet
@onready var fired_bullet_anim: AnimationPlayer = $FiredBullet/anim
@onready var break_sfx: AudioStreamPlayer = $"../sfx/break"
@onready var success_anim: AnimationPlayer = $"../SuccesVfx/anim"
@onready var words: Control = $"../Words"
var bullets = ["strange_place", "lost_memory"]
var target_location: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func truth_shoot():
	var mouse_pos = get_viewport().get_mouse_position()
	if downtime.time_left > 0.0:
		return
	target_location = get_viewport().get_mouse_position()
	crosshair_anim.stop()
	crosshair_anim.play("shoot")
	big_gunshot.play()
	shoot_anim.stop()
	shoot_anim.play("shoot")
	downtime.start(2.0)
	fired_bullet.global_position = target_location
	fired_bullet_anim.play("shoot_target")
	
func white_noise_shoot():
	crosshair_anim.stop()
	crosshair_anim.play("shoot")
	noise_anim.stop()
	noise_anim.play("shoot")
	small_gunshot.play()
	if debate_root.state == "bullet_preview":
		debate_root.debate_camera_reset()
	if crosshair.touching:
		debate_root.timer -= 15
		time_lose.play()
func check_hit():
	succes_hit()
	words.visible = false
	
func _on_downtime_timeout() -> void:
	reload()
func reload():
	shoot_anim.play("reload")
	
func succes_hit():
	debate_root.state = "success"
	crosshair.visible = false
	break_sfx.play()
	success_anim.play("success")
	print("SUCCESFULLY HIT!!!!")
