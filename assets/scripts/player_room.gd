extends Node3D

@onready var dialog : Control = $UI/Dialog
@onready var label : NinePatchRect = $UI/Base/Hover_label
var character_info = preload("res://assets/data/characters/characters.json").data
var camera = null

var current_hover = null
var current_hover_check = null
const RAY_LENGTH = 1000

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	camera = get_tree().get_first_node_in_group("Camera_room")
		
func run(object):
	if object == "raito":
		dialog.file = load("res://assets/data/dialog/test2.json")
		dialog.start()
	elif object == "nori":
		dialog.file = load("res://assets/data/dialog/test.json")
		dialog.start()

func _process(_delta: float) -> void:
	if current_hover != null and current_hover_check != current_hover and dialog.active == false:
		current_hover_check = current_hover
		label.get_node("Label").text = character_info[current_hover.name].name
		label.get_node("Anim").play("Open")
	if dialog.active == false and current_hover == null:
		current_hover_check = null
		label.get_node("Anim").play("Close")
	if current_hover and Input.is_action_just_pressed("Progress"):
		var name_send = current_hover.name
		current_hover = null
		current_hover_check = null
		label.get_node("Anim").play("Close")
		run(name_send)

func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result.has("collider") and result.collider.get_parent().get_parent() and result.collider.get_parent().get_parent().name == "Characters":
		current_hover = result.collider.get_parent()
	else:
		current_hover = null
