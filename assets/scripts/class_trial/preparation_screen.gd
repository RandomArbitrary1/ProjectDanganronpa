extends Control
@onready var class_trial_main: Node3D = $".."
@onready var revolver_cylinder: TextureRect = $pre_screen/revolver_cylinder
@onready var intro: Control = $"../Intro"
@onready var pre_screen: Control = $pre_screen
@onready var dialog: Control = $"../Dialog"
@onready var camera_3d: Node3D = $"../CameraNode"
@onready var message: Label = $pre_screen/message
@onready var message_2: Label = $pre_screen/message2
var state = ""
var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro.visible = false
	dialog.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#start_intro() # Use to speed up for testing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	message.position.x -= delta * 91
	message_2.position.x -= delta * 91
	if message_2.position.x < 0.0:
		message.position.x = 0.0
		message_2.position.x = 1970.0
	revolver_cylinder.rotation += delta * 0.3
	
	if intro.hide_elms:
		state = "hide"
		pre_screen.visible = false
		intro.hide_elms = false
		dialog.visible = true

	if intro.started:
		class_trial_main.start()
		intro.started = false

func _on_button_pressed() -> void:
	start_intro()
	
func start_intro():
	intro.visible = true
	intro.get_node("./anim").play("intro")
