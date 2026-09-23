extends Control
@onready var revolver: TextureRect = $revolver
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var confirm_sfx: AudioStreamPlayer = $confirm_sfx
@onready var panel: Panel = $Panel
var state = "press_any"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == "press_any":
		panel.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	revolver.rotation += delta * 0.5
	if state == "menu":
		panel.visible = true
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed or event is InputEventMouseButton:
		if state == "press_any":
			anim.play("menu_init")
			confirm_sfx.play()
			state = "menu"


func _on_start_new_game_pressed() -> void:
	exiting()
	LoadingScreen.load_scene("res://scenes/class_trial/trial_ground.tscn")


func _on_continue_pressed() -> void:
	exiting()
	LoadingScreen.load_scene("res://scenes/rooms_fps/school_f1.tscn")

func _on_options_pressed() -> void:
	exiting()
	LoadingScreen.load_scene("res://scenes/rooms_fps/factory_area.tscn")

func _on_quit_pressed() -> void:
	exiting()
	get_tree().quit()

func exiting():
	var state = "loading"
	panel.position = Vector2(-9999,-9999)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	confirm_sfx.play()
