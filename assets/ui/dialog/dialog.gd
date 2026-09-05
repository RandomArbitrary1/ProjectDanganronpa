extends Control

@export var file: Resource 
@export var active: bool
@export var camera: NodePath 
@onready var box = self.get_node("Bar/Dialog")
@onready var anim = self.get_node("Anims")
@onready var nameplate = self.get_node("Bar/Name")
@onready var decoration = self.get_node("Bar/Decoration")
@onready var switch = self.get_node("Bar/Switch")
@onready var input_ind = self.get_node("Bar/Input_indicator/Anim")

var dialog = null
var line = 1
var tween = null
var name_size = 0

func color(val):
	if val == "Player":
		return Color(0.861, 0.675, 0.634, 1.0)
	elif val == "Person1":
		return Color(0.554, 0.688, 1.0, 1.0)
	elif val == "Person2":
		return Color(0.709, 0.839, 0.0, 1.0)
	

func next():
	if dialog.has("dialog" + str(line)):
		var current = dialog.get("dialog" + str(line))
		input_ind.play("RESET")
		if current.type == "Text":
			if nameplate.get_node("Label").text != current.character and line != 0:
				switch.play("Switch")
			nameplate.get_node("Label").text = current.character
			get_node(camera).character = current.character
			#nameplate.self_modulate = color(current.character)
			name_size = nameplate.get_node("Label").get_minimum_size().x+110
			if line == 0:
				nameplate.size.x = name_size
			#decoration.self_modulate = color(current.character)
			box.text = current.content
			for i in current.flags:
				if i == "Thought":
					box.text = "[color=cyan]" + box.text + "[/color]"
			if line == 0:
				await anim.animation_finished
			tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, current.content.length()*.03).from(0.0)
			await tween.finished
			input_ind.play("Show")
	else:
		get_node(camera).character = ""
		anim.play("Close")
		await anim.animation_finished
		active = false

func start():
	if file and not active:
		dialog = file.data
		line = 1
		box.visible_ratio = 0.0
		anim.play("Open")
		next()
		active = true
		

func _process(delta: float) -> void:
	nameplate.size.x = move_toward(nameplate.size.x, name_size, 500*delta)
	if Input.is_action_just_pressed("Progress") and active:
		if box.visible_ratio == 1.0:
			line += 1
			next()
		else:
			if tween:
				tween.kill()
				box.visible_ratio = 1.0
				input_ind.play("Show")
		
