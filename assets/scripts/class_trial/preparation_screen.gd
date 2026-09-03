extends Control
@onready var class_trial_main: Node3D = $".."
@onready var revolver_cylinder: TextureRect = $revolver_cylinder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	revolver_cylinder.rotation += delta * 0.3


func _on_button_pressed() -> void:
	class_trial_main.state = "debate"
