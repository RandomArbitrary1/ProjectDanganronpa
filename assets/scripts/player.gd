extends CharacterBody3D


var SPEED = 6.5
var JUMP_VELOCITY = 5.0

@export var TILT_LOWER_LIMIT := deg_to_rad(-45.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(45.0)
@onready var CAMERA_CONTROLLER = $Camera3D
@export var MOUSE_SENSITIVITY : float = 0.3 
@onready var walk_anim = self.get_node("Camera3D/Walk")
@onready var dialog = self.get_parent().get_node("UI/Dialog")

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


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
		
		var target_anim = "bobbing" if direction != Vector3.ZERO else "RESET"

		if target_anim != "RESET" and walk_anim.current_animation != target_anim:
			walk_anim.play(target_anim)

		move_and_slide()
		_update_camera(delta)


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
	walk_anim.speed_scale = SPEED*.231
	if Input.is_action_pressed("Sprint"):
		SPEED = lerp(SPEED,13.0, 20*delta)
	else:
		SPEED = lerp(SPEED,6.5, 20*delta)
	if Input.is_action_just_pressed("RMB"):
		get_tree().quit()
