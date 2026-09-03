extends Camera3D

@export var minX: float
@export var minY: float
@export var maxX: float
@export var maxY: float
@export var speed: float
@export var character: String
@export var characters: NodePath 
var angle = Vector2(0,0)

var start_position = self.position
var start_rotation = self.rotation_degrees
var mouse_start = Vector2.ZERO
var angle_start = Vector2.ZERO


func _process(delta: float) -> void:
	if character == "":
		self.position = self.position.move_toward(start_position, 25*delta)
		self.rotation_degrees = start_rotation+Vector3(angle.y,angle.x,0)
	else:
		var chr = get_node(str(characters) + "/" + character)
		var direction = (start_position - chr.position).normalized()
		self.rotation = self.rotation.move_toward(Vector3(0,atan2(direction.x, direction.z),0), 10*delta)
		self.position = self.position.move_toward(chr.position + self.global_transform.basis*Vector3(0,.2,.5), 25*delta)
	
	if Input.is_action_pressed("Up"):
		angle = Vector2(clamp(angle.x,minX,maxX),clamp(angle.y+delta*speed,minY,maxY))
	if Input.is_action_pressed("Down"):
		angle = Vector2(clamp(angle.x,minX,maxX),clamp(angle.y-delta*speed,minY,maxY))
	if Input.is_action_pressed("Left"):
		angle = Vector2(clamp(angle.x+delta*speed,minX,maxX),clamp(angle.y,minY,maxY))
	if Input.is_action_pressed("Right"):
		angle = Vector2(clamp(angle.x-delta*speed,minX,maxX),clamp(angle.y,minY,maxY))
	
	if Input.is_action_just_pressed("RMB"):
		mouse_start = get_viewport().get_mouse_position()
		angle_start = angle
	if Input.is_action_pressed("RMB"):
		var offset = (get_viewport().get_mouse_position()-mouse_start)/30.0
		var angle_end = angle_start + Vector2(-offset.x, -offset.y)
		angle = Vector2(clamp(angle_end.x,minX,maxX),clamp(angle_end.y,minY,maxY))
