extends Control
@onready var dialog: Control = $Dialog



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog.file = load("res://assets/data/dialog/prologue/intro1.json")
	dialog.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
