extends Control
@onready var concentrate: TextureProgressBar = $Concentrate
@onready var hp: TextureProgressBar = $HP
@onready var slow_sfx: AudioStreamPlayer = $"../sfx/slow_sfx"
var concen_value = 100
var hp_value = 100

var speed_state = ""
var slow_down_done = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	concen_value = 100
	hp_value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if concen_value > 100:
		concen_value = 100
	speed_state = ""
	if Input.is_action_pressed("Spacebar"):
		if concen_value > 0.0:
			if not slow_sfx.playing:
				slow_sfx.play()
			speed_state = "slow"
			concen_value -= 35 * delta
	else:
		concen_value += 28 * delta
	if Input.is_action_pressed("Ctrl"):
		speed_state = "fast"
	if !speed_state == "slow":
		slow_sfx.stop()
	concentrate.value = concen_value
