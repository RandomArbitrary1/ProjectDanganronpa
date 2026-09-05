extends Node3D
@export var sprite:Texture2D
@onready var character: MeshInstance3D = $character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func swap():
	var mat = character.get_active_material(0).duplicate()
	mat.albedo_texture = sprite
	character.set_surface_override_material(0, mat)
	print("SWAPPED!")
