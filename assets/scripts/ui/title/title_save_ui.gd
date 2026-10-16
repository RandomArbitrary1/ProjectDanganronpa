extends Control

@onready var items: Control = $Items
@onready var anims: AnimationPlayer = $Anims
@onready var confirm_sfx: AudioStreamPlayer = $confirm_sfx
@onready var select_sfx: AudioStreamPlayer = $select_sfx


var tab = 0
var tab_max = 4
var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.switch("res://assets/audio/music/title.mp3")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not active:
		return
	for i in items.get_children():
		if i.get_index() == tab:
			i.get_node("Hover").size.x = move_toward(i.get_node("Hover").size.x, i.size.x+104, 4750*delta)
		else:
			i.get_node("Hover").size.x = move_toward(i.get_node("Hover").size.x, 104, 4750*delta)
		i.mouse_entered.connect(func():
			select_sfx.play()
		)
		if Rect2(i.global_position, i.size).has_point(get_global_mouse_position()):
			if tab != i.get_index() and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				tab = i.get_index()
			
	if Input.is_action_just_pressed("Up"):
		select_sfx.play()
		if tab > 0:
			tab -= 1
		else:
			tab = tab_max-1
	if Input.is_action_just_pressed("Down"):
		select_sfx.play()
		if tab < tab_max-1:
			tab += 1
		else:
			tab = 0
	
	if Input.is_action_just_pressed("Progress"):
		confirm_sfx.play()
		print(tab)
		if tab == 0:
			LoadingScreen.load_scene("res://scenes/ui/intro.tscn")
		elif tab == 2:
			get_tree().quit()
