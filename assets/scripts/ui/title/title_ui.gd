extends Control
@onready var revolver: TextureRect = $revolver
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var confirm_sfx: AudioStreamPlayer = $confirm_sfx


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	revolver.rotation += delta
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed or event is InputEventMouseButton:
		anim.play("press_any")
		confirm_sfx.play()
