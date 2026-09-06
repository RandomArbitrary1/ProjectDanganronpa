extends ColorRect

@onready var anim = self.get_node("Anim")
@onready var tabs = self.get_node("Tabs/List")

var open = false
var tab = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("handbook"):
		if open:
			open = false
			anim.play("Close")
			await anim.animation_finished
			get_tree().paused = false
		else:
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
				
	
	if Input.is_action_just_pressed("Next"):
		if tab < 5:
			tab += 1
		else:
			tab = 0
	if Input.is_action_just_pressed("Previous"):
		if tab > 0:
			tab -= 1
		else:
			tab = 5
			
	for i in tabs.get_child_count():
		var current = tabs.get_child(i)
		if i == tab:
			current.self_modulate.a = lerp(current.self_modulate.a, 1.0, 20*delta)
			current.get_node("Icon").modulate = current.get_node("Icon").modulate.lerp(Color(0.0,0.0,0.0), 20*delta)
		else:
			current.self_modulate.a = lerp(current.self_modulate.a, 0.0, 20*delta)
			current.get_node("Icon").modulate = current.get_node("Icon").modulate.lerp(Color(1.0,1.0,1.0), 20*delta)
		
