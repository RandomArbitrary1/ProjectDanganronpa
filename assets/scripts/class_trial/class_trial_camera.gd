extends Node3D

@onready var camera_node: Camera3D = $"."
var state = ""
var height = Vector3(0,1.6,0)
var rotate_value := 0.0 # is rotation
var radius := 14.0 # is distance
var angle := 1.9
var tween: Tween
var shake_strength := 0.0
var shake_decay := 0.3
var timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = ""
	angle = 1.9
	radius = 14.0
	rotate_value = 0.0
	height = Vector3(0,1.6,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "debate_spin":
		radius -= delta * 3.2
		if angle > 0.0:
			angle -= delta * 1.3 * 0.1
		rotate_value += delta * 2.1
		global_position = height + Vector3(sin(rotate_value) * radius, 
		angle,
		cos(rotate_value) * radius)
		look_at(height)
		rotate_object_local(Vector3.FORWARD, deg_to_rad(-18))
	if state == "intro_short_spin":
		rotate_value += delta * 2.1
		global_position = height + Vector3(sin(rotate_value) * radius, 
		angle,
		cos(rotate_value) * radius)
		timer += delta
		if timer > 1.0:
			state = "debate_spin"
			
	if shake_strength > 0.0:
		shake_strength = move_toward(shake_strength, 0.0, shake_decay * delta)
		self.h_offset = randf_range(-shake_strength, shake_strength)
		self.v_offset = randf_range(-shake_strength, shake_strength)
	else:
		self.h_offset = 0.0
		self.v_offset = 0.0
	
func fov(value):
	camera_node.fov = value
	
func set_pos(pos):
	global_position = pos
	
func set_rotat(rotat):
	rotation = rotat
func debate_spin():
	state = "intro_short_spin"
	
func succes_shake():
	pass

func shake(amount: float) -> void:
	shake_strength = amount

func focus_on(target_pos:Vector3):
	if tween:
		tween.kill()
	var from_transform = global_transform
	look_at(target_pos)                  # this snaps instantly...
	var target_basis = global_basis      # ...so grab the result...
	global_transform = from_transform    # ...then immediately revert the snap

	tween = create_tween()
	tween.tween_property(self, "global_basis", target_basis, 1)
