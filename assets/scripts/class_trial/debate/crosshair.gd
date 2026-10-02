extends Control
@onready var inner_crosshair: TextureRect = $inner_crosshair
@onready var outer_crosshair: TextureRect = $outer_crosshair
@onready var words: Control = $"../Words"
@onready var debate_root: Control = $".."
@onready var bullets_main: Control = $"../Bullets"

var touching = false
var was_touching = false

var tween_inner: Tween = create_tween()
var tween_outer: Tween = create_tween()
var tween_inner_rotation: Tween = create_tween()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween_change()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	inner_crosshair.rotation += delta * 0.4
	if !touching:
		outer_crosshair.rotation -= delta * 0.4
	if touching != was_touching:
		was_touching = touching
		tween_change()

	collision()

func tween_change():
	tween_inner.kill()
	tween_outer.kill()
	tween_inner_rotation.kill()
	tween_inner = create_tween()
	tween_outer = create_tween()
	tween_inner_rotation = create_tween()
	
	var inner_vector = Vector2(0.6,0.6)
	var outer_vector = Vector2(1.0,1.0)
	if touching:
		inner_vector = Vector2(1.0,1.0)
		outer_vector = Vector2(0.8,0.8)
	tween_inner.tween_property(inner_crosshair, "scale", inner_vector, 0.14)
	tween_outer.tween_property(outer_crosshair, "scale", outer_vector, 0.14)
	tween_inner_rotation.tween_property (outer_crosshair, "rotation", 0.0, 0.12)
	
func collision():
	touching = false
	for w in words.get_children():
		if Rect2(w.global_position, w.size).has_point(get_global_mouse_position()):
			touching = true

func _input(_event: InputEvent) -> void:
	if !debate_root.state == "debate":
		return
	if Input.is_action_just_pressed("RMB"):
		bullets_main.white_noise_shoot()
	if Input.is_action_just_pressed("LMB"):
		bullets_main.truth_shoot()
