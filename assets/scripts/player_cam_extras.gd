extends Camera3D

@export var minX: float
@export var minY: float
@export var maxX: float
@export var maxY: float
@export var speed: float
@export var character: String
var characters = Node3D
var angle = Vector2(0,0)
var global_pos_current = null
var global_rotation_current = null
var global_transform_current = null
var past_char = null
var tween_pos = null
var tween_rot = null

var start_position = Vector3(0,.65,0)
var start_rotation = self.rotation_degrees
var mouse_start = Vector2.ZERO
var angle_start = Vector2.ZERO

var character_info = preload("res://assets/data/characters/characters.json").data

func _ready() -> void:
	characters = get_tree().get_first_node_in_group("Characters_interact")


func _process(delta: float) -> void:
	if character == "":
		global_pos_current = null
		self.position = self.position.move_toward(start_position, 25*delta)
		self.fov = move_toward(self.fov, 50.0, 165*delta)
	else:
		var chr = characters.get_node_or_null(character)
		if chr:
			if global_pos_current == null:
				global_pos_current = self.global_position
			if past_char != chr:
				if tween_pos:
					tween_pos.kill()
				if tween_rot:
					tween_rot.kill()
				var direction = (chr.global_position - global_pos_current).normalized()
				past_char = chr
				global_rotation_current = atan2(-direction.x, -direction.z)
				global_transform_current = Basis(Vector3.UP, global_rotation_current)
				var pos_y = (1-character_info[character].face_pos[1]-.5)*2.2
				tween_pos = create_tween()
				tween_pos.tween_property(self, "global_position", chr.global_position + global_transform_current*Vector3(0,pos_y,2.2), .2).from(global_position)
				tween_rot = create_tween()
				tween_rot.tween_property(self, "global_rotation", Vector3(0,global_rotation_current,0), .2).from(global_rotation)
			self.fov = move_toward(self.fov, 40.0, 165*delta)
