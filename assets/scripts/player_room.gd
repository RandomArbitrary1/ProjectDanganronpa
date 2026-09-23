extends Camera3D

@export var minX: float
@export var minY: float
@export var maxX: float
@export var maxY: float
@export var speed: float
@export var character: String
var angle = Vector2(0,0)

@onready var dialog : Control = $UI/Dialog
@onready var reticle: TextureRect = $UI/Reticle
@onready var reticle_anim: AnimationPlayer = $UI/Reticle/Reticle_anim
@onready var tooltip: TextureRect = $UI/Reticle/tooltip

var character_info = preload("res://assets/data/characters/characters.json").data
const RAY_LENGTH = 1000
var characters = []

var reticle_talk = preload("res://assets/ui/base/reticle_talk.png")
var reticle_inspect = preload("res://assets/ui/base/reticle_inspect.png")

var current_hover_type = "character"
var current_hover = null
var current_hover_check = null
@onready var start_position = self.position
@onready var start_rotation = self.rotation_degrees
var mouse_start = Vector2.ZERO
var angle_start = Vector2.ZERO

var previous_dialog_state = false

var reticle_pos = "mouse"
var controller_reticle_pos = Vector2(960,540)
const DEADZONE = 0.15

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	characters = get_tree().get_first_node_in_group("Characters_interact")
	reticle.get_node("Anim").play("Show")

func _process(delta: float) -> void:
	if (reticle_pos == "mouse" and get_viewport().get_mouse_position().x < 960) or (reticle_pos == "controller" and controller_reticle_pos.x < 960):
		tooltip.flip_h = false
		tooltip.get_node("Label").position.x = 648
	else:
		tooltip.flip_h = true
		tooltip.get_node("Label").position.x = 8
	if dialog.active != previous_dialog_state:
		previous_dialog_state = dialog.active
		if dialog.active:
			reticle.get_node("Anim").play("Hide")
		else:
			reticle.get_node("Anim").play("Show")
			reticle_anim.play("Exit")
	if not dialog.active:
		if reticle_pos == "mouse":
			reticle.position = get_viewport().get_mouse_position() - Vector2(48,48)
		elif reticle_pos == "controller":
			reticle.position = controller_reticle_pos
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
			self.position = self.position.move_toward(chr.position + self.global_transform.basis*Vector3(0,.3,2.2), 20*delta)
	
	if self.get_parent().name != "Player":
		if dialog.active == false:
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
		
		if not dialog.active:
			var joy_x_left = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
			var joy_y_left = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
			if abs(joy_x_left) < DEADZONE: joy_x_left = 0.0
			if abs(joy_y_left) < DEADZONE: joy_y_left = 0.0
			if joy_x_left != 0.0 or joy_y_left != 0.0:
				reticle_pos = "controller"
				controller_reticle_pos.x = clamp(controller_reticle_pos.x+joy_x_left*5,-48, 1872)
				controller_reticle_pos.y = clamp(controller_reticle_pos.y+joy_y_left*5, -48, 1032)
		
		if Input.is_action_just_pressed("RMB"):
			mouse_start = get_viewport().get_mouse_position()
			angle_start = angle
		if Input.is_action_pressed("RMB"):
			if dialog.active == false:
				var offset = (get_viewport().get_mouse_position()-mouse_start)/30.0
				var angle_end = angle_start + Vector2(-offset.x, -offset.y)
				angle = Vector2(clamp(angle_end.x,minX,maxX),clamp(angle_end.y,minY,maxY))
	if current_hover != null and current_hover_check != current_hover and dialog.active == false:
		current_hover_check = current_hover
		if current_hover_type == "character":
			tooltip.get_node("Label").text = character_info[current_hover.name].name
		elif current_hover_type == "object":
			tooltip.get_node("Label").text = current_hover.display_name
		elif current_hover_type == "door":
			tooltip.get_node("Label").text = current_hover.name
		tooltip.get_node("Anim").play("Show")
		reticle_anim.play("Hover")
		
	if dialog.active == false and current_hover == null and current_hover_check != current_hover:
		current_hover_check = null
		tooltip.get_node("Anim").play("Hide")
		reticle_anim.play("Exit")
	if current_hover and Input.is_action_just_pressed("Progress") and not dialog.active:
		if (current_hover_type == "character" or current_hover_type == "object") and current_hover.dialog != "":
			dialog.file = load(current_hover.dialog)
			current_hover = null
			current_hover_check = null
			tooltip.get_node("Anim").play("Hide")
			dialog.start()
		elif current_hover_type == "door"  and current_hover.room != "":
			if current_hover.name != "Leave":
				var scene = current_hover.room
				var scene_name = current_hover.name
				current_hover = null
				current_hover_check = null
				reticle.get_node("Anim").play("Hide")
				RoomSwitch.switch(scene, scene_name)
			else:
				dialog.file = load("res://assets/data/leave.json")
				tooltip.get_node("Anim").play("Hide")
				dialog.start()
	if Input.is_action_just_pressed("Leave"):
		dialog.file = load("res://assets/data/leave.json")
		tooltip.get_node("Anim").play("Hide")
		dialog.start()
		


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
	if reticle_pos == "controller":
		mousepos = controller_reticle_pos+Vector2(48,48)

	var origin = self.project_ray_origin(mousepos)
	var end = origin + self.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result.has("collider") and result.collider.get_parent().get_parent(): 
		if result.collider.get_parent().get_parent().name == "Characters":
			current_hover_type = "character"
			if reticle.get_node("Indicator").texture != reticle_talk:
				reticle.get_node("Indicator").texture = reticle_talk
			current_hover = result.collider.get_parent()
		elif result.collider.get_parent().get_parent().name == "Objects":
			current_hover_type = "object"
			if reticle.get_node("Indicator").texture != reticle_inspect:
				reticle.get_node("Indicator").texture = reticle_inspect
			current_hover = result.collider.get_parent()
		elif result.collider.get_parent().get_parent().name == "Doors":
			current_hover_type = "door"
			if reticle.get_node("Indicator").texture != reticle_inspect:
				reticle.get_node("Indicator").texture = reticle_inspect
			current_hover = result.collider.get_parent()
		else:
			current_hover = null
	else:
		current_hover = null

var old_mouse_position : Vector2
func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.position.distance_to(old_mouse_position) > 100:
			reticle_pos = "mouse"
	elif event is InputEventJoypadButton or event is InputEventKey:
		old_mouse_position = get_viewport().get_mouse_position()
