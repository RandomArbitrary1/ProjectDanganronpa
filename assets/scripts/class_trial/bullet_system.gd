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
@onready var main_root: Control = $".."
var bullets = ["strange_place", "lost_memory"]

var bullet_direction = Vector3(0,0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func truth_shoot():
	var mouse_pos = get_viewport().get_mouse_position()
	if downtime.time_left > 0.0:
		return
	crosshair_anim.stop()
	crosshair_anim.play("shoot")
	big_gunshot.play()
	shoot_anim.stop()
	shoot_anim.play("shoot")
	downtime.start(2.0)
	#var ray_origin = camera.get_node("ClassTrialCamera").project_ray_origin(mouse_pos)
	var ray_direction = camera.get_node("ClassTrialCamera").project_ray_normal(mouse_pos)
	bullet_direction = ray_direction.normalized()
	
func white_noise_shoot():
	crosshair_anim.stop()
	crosshair_anim.play("shoot")
	noise_anim.stop()
	noise_anim.play("shoot")
	small_gunshot.play()
	if main_root.state == "bullet_preview":
		main_root.debate_camera_reset()

func _on_downtime_timeout() -> void:
	reload()
func reload():
	shoot_anim.play("reload")
