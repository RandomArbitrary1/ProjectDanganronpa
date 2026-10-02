extends Control
@onready var concentrate: TextureProgressBar = $Concentrate
@onready var hp: TextureProgressBar = $HP
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
		speed_state = "slow"
		concen_value -= 40 * delta
	else:
		concen_value += 30 * delta
	if Input.is_action_pressed("Ctrl"):
		speed_state = "fast"
	concentrate.value = concen_value
