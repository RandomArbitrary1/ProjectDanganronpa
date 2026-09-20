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
@onready var class_trial_char_bust: TextureRect = self.get_node("Bar/Display/Mask/Character")
@onready var full_name: Label = $Bar/Name/full_name
@onready var flash: AnimationPlayer = $Flash/Anim
@onready var dialog_anim: AnimationPlayer = $Bar/Dialog/Anim
@onready var choice_anim: AnimationPlayer = $Choice/Anim


var character_info = preload("res://assets/data/characters/characters.json").data
var dialog = null
var line = 0
var tween = null
var name_size = 0

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera_room")
	
func next(): # Next dialog line
	if dialog.size() > line:
		dialog_anim.play("RESET")
		var current = dialog[line]
		
		if current.type == "text": # Type of dialog node. This is a text dialog node
			box.visible_ratio = 0.0
			if full_name.text != character_info[current.character].name and line != 0:
				switch.play("Switch")
				
			full_name.text = character_info[current.character].name
			
			if camera and "character" in camera and camera.character != null:
				camera.character = current.character
			if class_trial_char_bust:
				var sprite = character_info[current.character].sprites["neutral"]
				var texture = load(sprite) as Texture2D
				class_trial_char_bust.texture = texture
				
			name_size = full_name.get_minimum_size().x+180
			box.text = current.content
			
			for i in current.flags:
				if i == "thought":
					box.text = "[color=cyan]" + box.text + "[/color]"
				elif i == "flash":
					flash.play("flash")
				elif i == "rage":
					dialog_anim.play("rage")
			if line == 0:
				await anim.animation_finished
				box.visible = true
				
			tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, current.content.length()*.03).from(0.0)
			await tween.finished
			input_ind.play("Show")
			print("Print is at 65 of dialog.gd, I think this might be bugged cuz input_int.play never plays, -Danilo")
		elif current.type == "bullet":
			if current.show == true:
				bullet.get_node("Mask/Image").texture = load(load(current.file).data[current.bullet].picture)
				bullet.get_node("Anim").play("Show")
				print(current.bullet)
			else:
				bullet.get_node("Anim").play("Hide")
			line += 1
			next()
		elif current.type == "music":
			Music.switch("res://assets/audio/music/" + current.song + ".mp3")
			line += 1
			next()
		elif current.type == "choice":
			choice_anim.play("Open")
		else:
			line += 1
			next()
		if dialog.size() > line+1:
			if dialog[line+1].type == "choice":
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
		box.visible = false
		box.visible_ratio = 0.0
		dialog = file.data.dialog
		line = 0
		input_ind.play("RESET")
		anim.play("Open")
		next()
		active = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Progress") and active:
		if box.visible_ratio == 1.0:
			line += 1
			input_ind.play("Next")
			next()
		else:
			if tween and dialog.size() > line:
				tween.kill()
				box.visible_ratio = 1.0
				input_ind.play("Show")
