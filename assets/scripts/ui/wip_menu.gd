extends Control

@onready var items: Control = $Items

var tab = 0
var tab_max = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in items.get_children():
		if i.get_index() == tab:
			i.get_node("Hover").size.x = move_toward(i.get_node("Hover").size.x, i.size.x+104, 3750*delta)
		else:
			i.get_node("Hover").size.x = move_toward(i.get_node("Hover").size.x, 104, 3750*delta)
		if Rect2(i.global_position, i.size).has_point(get_global_mouse_position()):
			if tab != i.get_index() and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				tab = i.get_index()
			
	if Input.is_action_just_pressed("Up"):
		if tab > 0:
			tab -= 1
		else:
			tab = tab_max-1
	if Input.is_action_just_pressed("Down"):
		if tab < tab_max-1:
			tab += 1
		else:
			tab = 0
	
	if Input.is_action_just_pressed("Progress"):
		print(tab)
	

var old_mouse_position : Vector2
func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.position.distance_to(old_mouse_position) > 100:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventJoypadButton or event is InputEventKey:
		old_mouse_position = get_viewport().get_mouse_position()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
