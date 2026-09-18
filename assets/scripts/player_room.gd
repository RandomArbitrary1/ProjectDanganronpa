extends Camera3D

@export var minX: float
@export var minY: float
@export var maxX: float
@export var maxY: float
@export var speed: float
@export var character: String
var angle = Vector2(0,0)

@onready var dialog : Control = $UI/Dialog
@onready var label : NinePatchRect = $UI/Base/Hover_label
var character_info = preload("res://assets/data/characters/characters.json").data
const RAY_LENGTH = 1000
var characters = []

var current_hover_type = "character"
var current_hover = null
var current_hover_check = null
var start_position = self.position
var start_rotation = self.rotation_degrees
var mouse_start = Vector2.ZERO
var angle_start = Vector2.ZERO

const DEADZONE = 0.15

func _ready() -> void:
	characters = get_tree().get_first_node_in_group("Characters_interact")


func _process(delta: float) -> void:
	if character == "" and self.get_parent().name != "Player":
		self.position = self.position.move_toward(start_position, 25*delta)
		self.rotation_degrees = start_rotation+Vector3(angle.y,angle.x,0)
		self.fov = move_toward(self.fov, 60.0, 165*delta)
	else:
		var chr = characters.get_node_or_null(character)
		if chr:
			self.fov = move_toward(self.fov, 40.0, 165*delta)
			var direction = (start_position - chr.position).normalized()
			self.rotation = self.rotation.move_toward(Vector3(0,atan2(direction.x, direction.z),0), 5*delta)
			self.position = self.position.move_toward(chr.position + self.global_transform.basis*Vector3(0,.5,2.2), 20*delta)
	
	if self.get_parent().name != "Player":
		if Input.is_action_pressed("Up"):
			angle = Vector2(clamp(angle.x,minX,maxX),clamp(angle.y+delta*speed,minY,maxY))
		if Input.is_action_pressed("Down"):
			angle = Vector2(clamp(angle.x,minX,maxX),clamp(angle.y-delta*speed,minY,maxY))
		if Input.is_action_pressed("Left"):
			angle = Vector2(clamp(angle.x+delta*speed,minX,maxX),clamp(angle.y,minY,maxY))
		if Input.is_action_pressed("Right"):
			angle = Vector2(clamp(angle.x-delta*speed,minX,maxX),clamp(angle.y,minY,maxY))
		
		var joy_x_right = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var joy_y_right = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		if abs(joy_x_right) < DEADZONE: joy_x_right = 0.0
		if abs(joy_y_right) < DEADZONE: joy_y_right = 0.0
		if joy_x_right != 0.0 or joy_y_right != 0.0:
			var x = -joy_x_right * delta * speed
			var y = -joy_y_right * delta * speed
			angle = Vector2(clamp(angle.x+x,minX,maxX),clamp(angle.y+y,minY,maxY))
		
		if Input.is_action_just_pressed("RMB"):
			mouse_start = get_viewport().get_mouse_position()
			angle_start = angle
		if Input.is_action_pressed("RMB"):
			var offset = (get_viewport().get_mouse_position()-mouse_start)/30.0
			var angle_end = angle_start + Vector2(-offset.x, -offset.y)
			angle = Vector2(clamp(angle_end.x,minX,maxX),clamp(angle_end.y,minY,maxY))
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
		


func run(object):
	if object == "raito":
		dialog.file = load("res://assets/data/dialog/test2.json")
		dialog.start()
	elif object == "nori":
		dialog.file = load("res://assets/data/dialog/test.json")
		dialog.start()


func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = self.project_ray_origin(mousepos)
	var end = origin + self.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result.has("collider") and result.collider.get_parent().get_parent() and result.collider.get_parent().get_parent().name == "Characters":
		current_hover = result.collider.get_parent()
	else:
		current_hover = null
