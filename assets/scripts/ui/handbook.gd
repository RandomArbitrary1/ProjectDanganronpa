extends TextureRect

@onready var anim : AnimationPlayer = $Anim
@onready var tabs = $Screen/Tabs/List
@onready var lists = $Screen/Lists

var original_mouse_mode = Input.MOUSE_MODE_HIDDEN
var open = false
var tab = 0
var inside_tab = Vector2.ZERO
@onready var current_tab_node = lists.get_node("System")
var tab_data = []

var x_range = 3
var y_range = 2

func _ready() -> void:
	for i in lists.get_children():
		var size_y = 1
		if i.get_node("Items").get_child_count() > 0:
			size_y = i.get_node("Items").get_child(1).custom_minimum_size.y
		tab_data.append({"offset":i.get_node("Items").position.y,"size":size_y+4})

func _process(delta: float) -> void:
	self.self_modulate = self.self_modulate.lerp(tabs.get_child(tab).self_modulate*Color(.5,.5,.5), 20*delta)
	if Input.is_action_just_pressed("handbook"):
		if open:
			Input.mouse_mode = original_mouse_mode
			open = false
			anim.play("Close")
			await anim.animation_finished
			get_tree().paused = false
			
		else:
			original_mouse_mode = Input.mouse_mode
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			open = true
			anim.play("Open")
			get_tree().paused = true
			tab = 0
			for i in tabs.get_child_count():
				var current = tabs.get_child(i)
				if i == tab:
					current.self_modulate.a = 1
					current.get_node("Icon").modulate = Color(0,0,0)
				else:
					current.self_modulate.a = 0
					current.get_node("Icon").modulate = Color(1,1,1)
				
	if get_tree().paused == true:
		if Input.is_action_just_pressed("Next"):
			if tab < 5:
				tab += 1
			else:
				tab = 0
			switch_tab()
		if Input.is_action_just_pressed("Previous"):
			if tab > 0:
				tab -= 1
			else:
				tab = 5
			switch_tab()
				
		for i in tabs.get_child_count():
			var current = tabs.get_child(i)
			if i == tab:
				current.self_modulate.a = lerp(current.self_modulate.a, 1.0, 20*delta)
				current.get_node("Icon").modulate = current.get_node("Icon").modulate.lerp(Color(0.0,0.0,0.0), 20*delta)
			else:
				current.self_modulate.a = lerp(current.self_modulate.a, 0.0, 20*delta)
				current.get_node("Icon").modulate = current.get_node("Icon").modulate.lerp(Color(1.0,1.0,1.0), 20*delta)
			if Input.is_action_just_pressed("LMB"):
				if Rect2(current.global_position, current.size).has_point(get_global_mouse_position()):
					tab = i
					switch_tab()
		
		if Input.is_action_just_pressed("Left"):
			if inside_tab.x > 0:
				inside_tab.x -= 1
			else:
				inside_tab.x = x_range-1
		if Input.is_action_just_pressed("Right"):
			if inside_tab .x < x_range-1:
				inside_tab.x += 1
			else:
				inside_tab.x = 0
		if Input.is_action_just_pressed("Up"):
			if inside_tab.y > 0:
				inside_tab.y -= 1
			else:
				inside_tab.y = y_range-1
		if Input.is_action_just_pressed("Down"):
			if inside_tab .y < y_range-1:
				inside_tab.y += 1
			else:
				inside_tab.y = 0
				
		
		for i in current_tab_node.get_node("Items").get_children():
			if i.get_index() == inside_tab.y * x_range + inside_tab.x:
				i.get_node("Outline").modulate.a = lerp(i.get_node("Outline").modulate.a, 1.0, 20*delta)
			else:
				i.get_node("Outline").modulate.a = lerp(i.get_node("Outline").modulate.a, 0.0, 20*delta)
			if Input.is_action_just_pressed("LMB"):
				if Rect2(i.global_position, i.size).has_point(get_global_mouse_position()):
					inside_tab.x = int(i.get_index() % x_range)
					inside_tab.y = int(i.get_index() / x_range)

	current_tab_node.get_node("Items").position.y = move_toward(current_tab_node.get_node("Items").position.y, clamp(tab_data[tab].offset-(inside_tab.y-1)*tab_data[tab].size,tab_data[tab].size-tab_data[tab].size*(y_range-3), tab_data[tab].offset), 1600*delta)


func _input(event: InputEvent) -> void:
	if open:
		if event is InputEventMouse:
			if event is not InputEventMouseButton:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event is InputEventJoypadButton or event is InputEventKey:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func switch_tab():
	inside_tab = Vector2.ZERO
	current_tab_node = lists.get_child(tab)
	x_range = current_tab_node.get_node("Items").columns
	y_range = int(current_tab_node.get_node("Items").get_child_count() / x_range)
	for i in lists.get_children():
		if i.get_index() == tab:
			i.visible = true
		else:
			i.visible = false
