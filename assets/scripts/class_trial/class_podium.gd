extends Node3D
@export var sprite:Texture2D
@export var char_name:String

@onready var character: MeshInstance3D = $character
@onready var shadow: MeshInstance3D = $shadow
var emotion:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func swap(path="res://assets/textures/characters/dummyman/dummy.png"):
	var mat = character.get_active_material(0).duplicate()
	var texture = load(path) as Texture2D
	mat.albedo_texture = texture
	character.set_surface_override_material(0, mat)
	mat = character.get_active_material(0).duplicate()
	mat.albedo_color = Color.BLACK
	shadow.set_surface_override_material(0, mat)
func pose(string):
	print(string)
func place_person(person=null):
	if !person:
		print("no person parsed!")
	if person:
		char_name = person
		print("'placed'", char_name)
		swap()
func expression(emotion):
	var emotion_path = "res://assets/textures/characters/dummyman/dummy.png"
	if emotion == "sad":
		emotion_path = "res://assets/textures/characters/dummyman/dummy_sad.png"
	if emotion == "angry":
		emotion_path = "res://assets/textures/characters/dummyman/dummy_angry.png"
	if emotion == "focus":
		emotion_path = "res://assets/textures/characters/dummyman/dummy_focus.png"
	if emotion == "determined":
		emotion_path = "res://assets/textures/characters/dummyman/dummy_determined.png"
	swap(emotion_path)
