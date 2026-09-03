extends Control

@export var file: Resource 
@export var active: bool
@export var camera: NodePath 
@onready var box = self.get_node("Bar/Dialog")
@onready var anim = self.get_node("Anims")
@onready var nameplate = self.get_node("Bar/Name")
@onready var decoration = self.get_node("Bar/Decoration")

var dialog = null
var line = 0
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
	if line < dialog.size():
		if dialog[line][0] == "Text":
			if nameplate.get_node("Label").text != dialog[line][1] and line != 0:
				anim.play("Switch")
			nameplate.get_node("Label").text = dialog[line][1]
			get_node(camera).character = dialog[line][1]
			nameplate.self_modulate = color(dialog[line][1])
			name_size = nameplate.get_node("Label").get_minimum_size().x+110
			if line == 0:
				nameplate.size.x = name_size
			decoration.self_modulate = color(dialog[line][1])
			box.text = dialog[line][4]
			if dialog[line].size() > 5:
				for i in dialog[line][5]:
					if i == "Thought":
						box.text = "[color=cyan]" + box.text + "[/color]"
			if anim.is_playing():
				await anim.animation_finished
			tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, dialog[line][4].length()*dialog[line][3]).from(0.0)
	else:
		get_node(camera).character = ""
		anim.play("Close")
		await anim.animation_finished
		active = false

func start():
	if file and not active:
		dialog = file.data
		line = 0
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
		
