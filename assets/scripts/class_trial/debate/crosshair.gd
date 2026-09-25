extends TextureRect
@onready var inner_crosshair: TextureRect = $inner_crosshair
@onready var words: Control = $"../Words"
@onready var debate_root: Control = $".."
@onready var bullets_main: Control = $"../Bullets"

var touching = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	inner_crosshair.rotation += delta * 0.9
	inner_crosshair.scale = Vector2(1,1)
	if touching:
		inner_crosshair.scale = Vector2(2.5,2.5)
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
