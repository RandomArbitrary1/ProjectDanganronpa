extends Node3D
@export var sprite:Texture2D
@export var char_name:String

@onready var character: MeshInstance3D = $character
@onready var shadow: MeshInstance3D = $shadow
@onready var rect_size:Vector2 = character.mesh.size
@onready var face_center = null
var char_data = null
var main = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().get_first_node_in_group("trial_main")
	char_data = main.char_data

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
		swap()
	calculate_face_pos()
#func expression(emotion):
	#var emotion_path = "res://assets/textures/characters/dummyman/dummy.png"
	#if emotion == "sad":
		#emotion_path = "res://assets/textures/characters/dummyman/dummy_sad.png"
	#if emotion == "angry":
		#emotion_path = "res://assets/textures/characters/dummyman/dummy_angry.png"
	#if emotion == "focus":
		#emotion_path = "res://assets/textures/characters/dummyman/dummy_focus.png"
	#if emotion == "determined":
		#emotion_path = "res://assets/textures/characters/dummyman/dummy_determined.png"
	#swap(emotion_path)
	
func calculate_face_pos():
	var height = char_data[char_name].face_pos
	var quad_size: Vector2 = character.mesh.size
	var y_offset = (0.5 - height[1]) * quad_size.y
	face_center = character.global_position + Vector3.UP * y_offset
	
func uv_to_local_position(uv: Vector2, quad_size: Vector2) -> Vector3:
	var x = (uv.x - 0.5) * quad_size.x
	var y = (0.5 - uv.y) * quad_size.y   # flip Y: UV down = world up negative
	return Vector3(x, y, 0)
