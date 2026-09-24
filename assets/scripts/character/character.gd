extends MeshInstance3D

@export var character : String
@export var expression : String
@export var dialog : String

var camera = Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	var sprite = load("res://assets/textures/characters/" + character + "/" + expression + ".png")
	if sprite:
		var mat : StandardMaterial3D = self.get_surface_override_material(0).duplicate()
		mat.albedo_texture = sprite
		self.set_surface_override_material(0,mat)
	rotation.y = atan2(
		camera.global_position.x - global_position.x,
		camera.global_position.z - global_position.z
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if camera.name != "Player":
		rotation.y = atan2(
			camera.global_position.x - global_position.x,
			camera.global_position.z - global_position.z
		)
