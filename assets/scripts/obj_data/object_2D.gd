extends MeshInstance3D

@export var dialog : String
@export var display_name : String

var camera = Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

	rotation.y = atan2(
		camera.global_position.x - global_position.x,
		camera.global_position.z - global_position.z
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotation.y = atan2(
		camera.global_position.x - global_position.x,
		camera.global_position.z - global_position.z
	)
