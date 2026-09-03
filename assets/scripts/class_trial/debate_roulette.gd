extends Control
@onready var crosshair: TextureRect = $crosshair


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	crosshair.position = get_local_mouse_position() - crosshair.size / 2
