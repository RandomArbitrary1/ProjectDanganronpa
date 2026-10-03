extends Control
var hide_elms = false
var started = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func start():
	started = true
	
func hide_elements():
	hide_elms = true
