extends Label
@onready var anim: AnimationPlayer = $anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func operate(char_data):
	anim.play("appear")
	text = str(char_data)
