extends Camera3D

@export var minX: float
@export var minY: float
@export var maxX: float
@export var maxY: float
@export var speed: float
@export var character: String
var characters = Node3D
var angle = Vector2(0,0)

var start_position = self.position
var start_rotation = self.rotation_degrees
var mouse_start = Vector2.ZERO
var angle_start = Vector2.ZERO

func _ready() -> void:
	characters = get_tree().get_first_node_in_group("Characters_interact")


func _process(delta: float) -> void:
	if character == "" and self.get_parent().name != "Player":
		self.position = self.position.move_toward(start_position, 25*delta)
		self.rotation_degrees = start_rotation+Vector3(angle.y,angle.x,0)
		self.fov = move_toward(self.fov, 75.0, 165*delta)
	else:
		var chr = characters.get_node_or_null(character)
		if chr:
			self.fov = move_toward(self.fov, 40.0, 165*delta)
			var direction = (start_position - chr.position).normalized()
			self.rotation = self.rotation.move_toward(Vector3(0,atan2(direction.x, direction.z),0), 5*delta)
			self.position = self.position.move_toward(chr.position + self.global_transform.basis*Vector3(0,.2,1), 20*delta)
	
	if self.get_parent().name != "Player":
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
