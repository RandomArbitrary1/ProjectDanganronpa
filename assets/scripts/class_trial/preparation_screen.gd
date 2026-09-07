extends Control
@onready var class_trial_main: Node3D = $".."
@onready var revolver_cylinder: TextureRect = $revolver_cylinder
@onready var intro: Control = $Intro
var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	revolver_cylinder.rotation += delta * 0.3
	if intro.visible:
		timer += delta
		if timer > 4.9:
			class_trial_main.state = "debate"


func _on_button_pressed() -> void:
	intro.visible = true
	intro.get_node("./anim").play("intro")
