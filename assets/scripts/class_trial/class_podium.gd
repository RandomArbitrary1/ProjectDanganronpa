extends Node3D
@export var sprite:Texture2D
@export var char_name:String

@onready var character: MeshInstance3D = $character
@onready var shadow: MeshInstance3D = $shadow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func swap():
	var mat = character.get_active_material(0).duplicate()
	mat.albedo_texture = sprite
	character.set_surface_override_material(0, mat)
	mat = character.get_active_material(0).duplicate()
	mat.albedo_color = Color.BLACK
	shadow.set_surface_override_material(0, mat)
	print("Sprite Updated")
func pose(string):
	print(string)
func place_person(person=null):
	if !person:
		print("no person parsed!")
	if person:
		char_name = person
		print("'placed'")
		print(char_name)
