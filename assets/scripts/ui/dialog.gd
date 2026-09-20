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
@onready var class_trial_char_bust: TextureRect = self.get_node_or_null("Bar/Display/Mask/Character")
@onready var full_name: Label = $Bar/Name/full_name
@onready var flash: AnimationPlayer = $Flash/Anim
@onready var dialog_anim: AnimationPlayer = $Bar/Dialog/Anim
@onready var choice_anim: AnimationPlayer = $ChoiceAnim
@onready var option_temp: NinePatchRect = $Choice/Option.duplicate()

var option_inactive = preload("res://assets/ui/dialog/choice.png")
var option_active = preload("res://assets/ui/dialog/choice_active.png")

var character_info = preload("res://assets/data/characters/characters.json").data
var dialog = null
var line = 0
var tween = null
var name_size = 0
var leave = false

var option_tab = 0
var option_tab_max = 0
var optioning = false

func _ready() -> void:
	$Choice/Option.queue_free()
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
			if line == 0 and dialog == file.data.dialog:
				await anim.animation_finished
				box.visible = true
				
			tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, current.content.length()*.03).from(0.0)
			await tween.finished
			input_ind.play("Show")
			print("Print is at 65 of dialog.gd, I think this might be bugged cuz THIS input_int.play never plays, -Danilo")
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
			optioning = true
			option_tab = 0
			option_tab_max = current.options.size()-1
			for i in $Choice.get_children():
				if i is NinePatchRect:
					i.queue_free()
			for i in current.options.size():
				var opt = current.options[i]
				var option = option_temp.duplicate()
				option.get_node("Text").text = opt.text
				option.position.y = 100*i
				option.set_meta("ID", opt.dialog)
				$Choice.add_child(option)
				
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
		if file.resource_path == "res://assets/data/leave.json":
			leave = true
		else:
			leave = false
		box.visible = false
		box.visible_ratio = 0.0
		dialog = file.data.dialog
		line = 0
		input_ind.play("RESET")
		anim.play("Open")
		next()
		active = true

func _process(_delta: float) -> void:
	for i in $Choice.get_children():
		if i.get_index() == option_tab:
			i.texture = option_active
		else:
			i.texture = option_inactive
	if Input.is_action_just_pressed("Up"):
		if option_tab > 0:
			option_tab -= 1
		else:
			option_tab = option_tab_max
	if Input.is_action_just_pressed("Down"):
		if option_tab < option_tab_max:
			option_tab += 1
		else:
			option_tab = 0
	if Input.is_action_just_pressed("Progress") and active:
		if optioning:
			choice_anim.play("Close")
			optioning = false
			var id = $Choice.get_child(option_tab).get_meta("ID")
			if id == "0":
				line += 1
				next()
			else:
				if not leave:
					line = 0
					dialog = file.data["dialog" + $Choice.get_child(option_tab).get_meta("ID")]
					next()
				else:
					get_tree().root
		else:
			if box.visible_ratio == 1.0:
				line += 1
				input_ind.play("Next")
				next()
			else:
				if tween and dialog.size() > line:
					tween.kill()
					box.visible_ratio = 1.0
					input_ind.play("Show")
