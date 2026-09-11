extends CharacterBody3D


var SPEED = 6.5
var JUMP_VELOCITY = 5.0
var character_info = preload("res://assets/data/characters/characters.json").data
@export var TILT_LOWER_LIMIT := deg_to_rad(-45.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(45.0)
@onready var CAMERA_CONTROLLER = $Camera3D
@export var MOUSE_SENSITIVITY : float = 0.3 
@onready var walk_anim = self.get_node("Camera3D/Walk")
@onready var dialog: Control = $UI/Dialog
@onready var base_gui: Control = $UI/Base
@onready var steps = self.get_node("Camera3D/Steps")
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var pointer = $UI/Pointer
const JOYSTICK_SENSITIVITY = 400
const DEADZONE = 0.15

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

var current_hover_check = null
var characters = []
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	characters = get_tree().get_nodes_in_group("Characters_interact")
	ray_cast_3d.collide_with_areas = true
	ray_cast_3d.collide_with_bodies = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not dialog.active:
		var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)


func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input :
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY


func _update_camera(delta):
	
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	#CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation = _camera_rotation
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	#global_transform.basis = Basis.from_euler(_player_rotation)
	global_rotation = _player_rotation
	
	_rotation_input = 0.0
	_tilt_input = 0.0

func _process(delta: float) -> void:
	if not dialog.active:
		var joy_x_left = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		var joy_y_left = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		if abs(joy_x_left) < DEADZONE: joy_x_left = 0.0
		if abs(joy_y_left) < DEADZONE: joy_y_left = 0.0
		if joy_x_left != 0.0 or joy_y_left != 0.0:
			var input_dir := Vector3(-joy_x_left, 0.0, -joy_y_left)
			input_dir = input_dir.rotated(Vector3.UP, global_rotation.y)
			velocity.x = -input_dir.x * JOYSTICK_SENSITIVITY * delta * SPEED/1.5
			velocity.z = -input_dir.z * JOYSTICK_SENSITIVITY * delta * SPEED/1.5
		
		var joy_x_right = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var joy_y_right = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		if abs(joy_x_right) < DEADZONE: joy_x_right = 0.0
		if abs(joy_y_right) < DEADZONE: joy_y_right = 0.0
		if joy_x_right != 0.0 or joy_y_right != 0.0:
			_rotation_input = -joy_x_right * JOYSTICK_SENSITIVITY * delta
			_tilt_input = -joy_y_right * JOYSTICK_SENSITIVITY * delta
			
		var target_anim = "bobbing" if velocity.x != 0 and velocity.z != 0 else "RESET"

		if target_anim != "RESET" and walk_anim.current_animation != target_anim:
			walk_anim.play(target_anim)
		if target_anim != "RESET" and not steps.is_playing():
			steps.play()
		
		move_and_slide()
		_update_camera(delta)
		
		pointer.modulate.a = lerp(pointer.modulate.a, 1.0, 20*delta)
	else:
		pointer.modulate.a = lerp(pointer.modulate.a, 0.0, 20*delta)
	
	walk_anim.speed_scale = SPEED*.231
	if Input.is_action_pressed("Sprint"):
		SPEED = lerp(SPEED,13.0, 20*delta)
		steps.pitch_scale = 2
	else:
		SPEED = lerp(SPEED,6.5, 20*delta)
		steps.pitch_scale = 1
	if Input.is_action_just_pressed("RMB"):
		get_tree().quit()
	var current_hover = null
	
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider.get_parent().get_parent() and collider.get_parent().get_parent().name == "Characters":
			current_hover = collider.get_parent()
	if current_hover != null and current_hover_check != current_hover and dialog.active == false:
		current_hover_check = current_hover
		base_gui.get_node("Hover_label/Label").text = character_info[current_hover.name].name
		base_gui.get_node("Hover_label/Anim").play("Open")
	if dialog.active == false and current_hover == null:
		current_hover_check = null
		base_gui.get_node("Hover_label/Anim").play("Close")
	if current_hover and Input.is_action_just_pressed("Progress"):
		var name_send = current_hover.name
		current_hover = null
		current_hover_check = null
		base_gui.get_node("Hover_label/Anim").play("Close")
		run(name_send)
		
func run(object):
	if object == "raito":
		dialog.file = load("res://assets/data/dialog/test2.json")
		dialog.start()
	elif object == "nori":
		dialog.file = load("res://assets/data/dialog/test.json")
		dialog.start()
