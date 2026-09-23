extends Control
@onready var class_trial_main: Node3D = $".."
@onready var revolver_cylinder: TextureRect = $pre_screen/revolver_cylinder
@onready var intro: Control = $"../Intro"
@onready var pre_screen: Control = $pre_screen
@onready var dialog: Control = $"../Dialog"
@onready var music_dialog: AudioStreamPlayer = $"../music_dialog"
@onready var camera_3d: Node3D = $"../CameraNode"
var state = ""
var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro.visible = false
	dialog.visible = false
	#start_intro()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	revolver_cylinder.rotation += delta * 0.3
	
	if intro.hide_elms:
		state = "hide"
		pre_screen.visible = false
		intro.hide_elms = false
		dialog.visible = true
		camera_3d.play("RESET")
	if intro.started:
		class_trial_main.start_dialog()
		intro.started = false

func _on_button_pressed() -> void:
	start_intro()
	
func start_intro():
	intro.visible = true
	intro.get_node("./anim").play("intro")
