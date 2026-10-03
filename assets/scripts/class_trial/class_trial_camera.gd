extends Node3D

@onready var camera_node: Camera3D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func play(animation:String):

	camera_node.global_position = Vector3.ZERO
	camera_node.rotation = Vector3.ZERO

func fov(value):
	camera_node.fov = value
	
func set_pos(pos):
	global_position = pos
	
func set_rotat(rotat):
	rotation = rotat
