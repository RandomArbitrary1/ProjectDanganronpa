extends Node3D
var state = "press_any"
@onready var dialog: Control = $Dialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog.file = load("res://assets/data/game/title_dialog_music.json")
	dialog.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
