extends Control

@export var file: Resource 
var active: bool
var camera = null
@onready var box = self.get_node("Bar/Dialog")
@onready var anim = self.get_node("Anims")
@onready var bullet = self.get_node("Bar/Bullet")
@onready var nameplate = self.get_node("Bar/Name")
@onready var switch = self.get_node("Bar/Switch")
@onready var input_ind = self.get_node("Bar/Input_indicator/Anim")
@onready var full_name: Label = $Bar/Name/full_name
var character_info = preload("res://assets/data/characters/characters.json").data
var dialog = null
var line = 0
var tween = null
var name_size = 0

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera_room")
	

func next():
	if dialog.size() > line:
		var current = dialog[line]
		input_ind.play("RESET")
		if current.type == "text":
			if full_name.text != current.character and line != 0:
				switch.play("Switch")
			full_name.text = character_info[current.character].name
			if  camera and "character" in camera and camera.character != null:
				camera.character = current.character
			name_size = full_name.get_minimum_size().x+110
			if line == 0:
				nameplate.size.x = name_size
			box.text = current.content
			for i in current.flags:
				if i == "thought":
					box.text = "[color=cyan]" + box.text + "[/color]"
			if line == 0:
				await anim.animation_finished
			tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, current.content.length()*.03).from(0.0)
			await tween.finished
			input_ind.play("Show")
		elif current.type == "bullet":
			if current.show == true:
				bullet.get_node("Anim").play("Show")
				print(current.bullet)
			else:
				bullet.get_node("Anim").play("Hide")
			line += 1
			next()
		else:
			line += 1
			next()
	else:
		if camera and "character" in camera and camera.character != null:
			camera.character = ""
		anim.play("Close")
		await anim.animation_finished
		active = false

func start():
	if file and not active:
		dialog = file.data.dialog
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
				input_ind.play("Show")
		
