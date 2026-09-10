extends Camera3D

@export var minX: float
@export var minY: float
@export var maxX: float
@export var maxY: float
@export var speed: float
@export var character: String
var characters = Node3D
var angle = Vector2(0,0)

var start_position = Vector3(0,.8,0)
var start_rotation = self.rotation_degrees
var mouse_start = Vector2.ZERO
var angle_start = Vector2.ZERO

func _ready() -> void:
	characters = get_tree().get_first_node_in_group("Characters_interact")


func _process(delta: float) -> void:
	if character == "":
		self.position = self.position.move_toward(start_position, 25*delta)
		self.fov = move_toward(self.fov, 60.0, 165*delta)
	else:
		var chr = characters.get_node_or_null(character)
		if chr:
			self.fov = move_toward(self.fov, 40.0, 165*delta)
			var direction = (chr.position - start_position).normalized()
			self.rotation = self.rotation.move_toward(Vector3(0,atan2(direction.x, direction.z),0), 5*delta)
			self.position = self.position.move_toward(chr.position + self.global_transform.basis*Vector3(0,.2,1), 20*delta)
