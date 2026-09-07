extends Node3D
@onready var animation_player: AnimationPlayer = $ClassTrialCamera/AnimationPlayer
@onready var camera_node: Node3D = $"."
@onready var class_trial_camera: Camera3D = $ClassTrialCamera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func play(animation:String):
	if animation == "stop":
		animation_player.stop()
		return
	animation_player.stop()
	camera_node.global_position = Vector3.ZERO
	camera_node.rotation = Vector3.ZERO
	animation_player.play(animation)
func fov(value):
	class_trial_camera.fov = value
