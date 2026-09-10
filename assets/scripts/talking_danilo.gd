extends Node3D


var camera = null


const RAY_LENGTH = 1000

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera_room")

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta):
	pass
