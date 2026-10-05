extends Control

#imports/paths

@export var file: Resource 
var active: bool
var camera = null
var characters = null
@onready var box = self.get_node("Bar/Dialog")
@onready var anim : AnimationPlayer = self.get_node("Anims")
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
@onready var sfx_dialog: AudioStreamPlayer = $SFX_dialog
@onready var sfx_next: AudioStreamPlayer = $SFX_next
@onready var sfx: AudioStreamPlayer = $SFX
@onready var cg: TextureRect = $CG
@onready var cg_fade: TextureRect = $CG_fade
@onready var cg_anim: AnimationPlayer = $CG_anim
@onready var cg_fade_anim: AnimationPlayer = $CG_fade_anim

#ui sfx
var next_sfx = preload("res://assets/audio/sfx/ui/dialog_next.mp3")
var confirm_sfx = preload("res://assets/audio/sfx/ui/confirm.mp3")
var select_sfx = preload("res://assets/audio/sfx/ui/select2.mp3")

const idea = preload("uid://cm4ro1uwswy2a")
const shock = preload("uid://v3ccuuxy11kt")
var option_inactive = preload("res://assets/ui/dialog/choice.png")
var option_active = preload("res://assets/ui/dialog/choice_active.png")
var character_info = preload("res://assets/data/characters/characters.json").data
const character = preload("res://assets/objects/characters/character.tscn")

#variables

var dialog = null
var tween = null
var mouse_old = null
var leave = false
var optioning = false
var cg_state = false
var line = 0
var name_size = 0
var option_tab = 0
var option_tab_max = 0
var last_anim = null
var instant_skip_timer = 0

#setup

func _ready() -> void:
	$Choice/Option.queue_free()
	camera = get_tree().get_first_node_in_group("Camera_room")
	characters = get_tree().get_first_node_in_group("Characters_interact")
	if RoomSwitch.dialog_next != null:
		file = load(RoomSwitch.dialog_next)
		RoomSwitch.dialog_next = null
		start()
	
func next(): # Next dialog line
	if mouse_old:
		Input.mouse_mode = mouse_old
	if dialog.size() > line:
		dialog_anim.play("RESET")
		var current = dialog[line]
		
		if current.type == "text": # Type of dialog node. This is a text dialog node
			if "sfx" in current:
				sfx.stream = load(current.sfx)
				sfx.play()
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
			box.visible = true # Placed here otherwise music node makes box not visible
			
			for i in current.flags:
				if i == "thought":
					box.text = "[color=#94d6ff]" + box.text + "[/color]"
				elif i == "idea":
					flash.play("flash")
					sfx_dialog.stream = idea
					sfx_dialog.play()
				elif i == "shock":
					flash.play("flash")
					sfx_dialog.stream = shock
					sfx_dialog.play()
				elif i == "rage":
					dialog_anim.play("rage")
				elif i == "unknown":
					full_name.text = "???"
			if line == 0 and dialog == file.data.dialog: # line == 0 ignores box visible if music node is present.
				await anim.animation_finished
				box.visible = true
				
			tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, current.content.length()*.03).from(0.0)
			await tween.finished
			input_ind.play("Show")
		elif current.type == "bullet":
			if current.show == true:
				bullet.get_node("Mask/Image").texture = load(load(current.file).data[current.bullet].picture)
				bullet.get_node("Anim").play("Show")
				last_anim = bullet.get_node("Anim")
				print(current.bullet)
			else:
				bullet.get_node("Anim").play("Hide")
				last_anim = bullet.get_node("Anim")
			line += 1
			next()
		elif current.type == "music":
			if "delay" in current:
				Music.switch("res://assets/audio/music/" + current.song + ".mp3", current.delay)
			else:
				Music.switch("res://assets/audio/music/" + current.song + ".mp3")
			line += 1
			next()
		elif current.type == "character":
			if not "spawn" in current or current.spawn == true:
				var new_char = find_child(current.character)
				if not new_char:
					new_char = character.instantiate()
					new_char.name = current.character
					new_char.character = current.character
				new_char.expression = current.expression
				if "file" in current:
					new_char.dialog = current.file
				characters.add_child(new_char)
				new_char.position = Vector3(current.x,current.y,current.z)
				new_char.get_node("Anim").play("Enter")
				await new_char.get_node("Anim").animation_finished
			else:
				var old_char = characters.find_child(current.character)
				old_char.get_node("Anim").play("Leave")
				await old_char.get_node("Anim").animation_finished
				old_char.queue_free()
			line += 1
			next()
		elif current.type == "room":
			RoomSwitch.dialog_next = current.dialog
			if "default" in current:
				RoomSwitch.switch(current.file, current.name, null, current.default)
			else:
				RoomSwitch.switch(current.file, current.name)
			line += 1
			next()
		elif current.type == "sfx":
			sfx.stream = load(current.file)
			sfx.play()
			line += 1
			next()
		elif current.type == "focus":
			if camera and "focus" in camera and camera.character != null:
				camera.focus = current.point
			line += 1
			next()
		elif current.type == "visible":
			if current.value:
				anim.play("Open")
				await anim.animation_finished
			else:
				anim.play("Close")
				await anim.animation_finished
			line += 1
			next()
		elif current.type == "cg":
			if current.enabled: 
				if not cg_state:
					cg.texture = load(current.file)
					cg_state = true
					cg_anim.play("Open")
					last_anim = cg_anim
					await cg_anim.animation_finished
					line += 1
					next()
				else:
					cg_fade.texture = load(current.file)
					cg_fade_anim.play("Fade")
					last_anim = cg_fade_anim
					await cg_fade_anim.animation_finished
					cg_fade_anim.play("RESET")
					cg.texture = load(current.file)
					line += 1
					next()
			elif cg_state:
				cg_state = false
				cg_anim.play("Close")
				last_anim = cg_anim
				await cg_anim.animation_finished
				line += 1
				next()
		elif current.type == "choice":
			mouse_old = Input.mouse_mode
			old_mouse_position = get_viewport().get_mouse_position()
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
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
				option.position.y = (120-current.options.size()*60)+60*i
				option.position.x = 240+i*-60
				option.size.x += i*60
				option.set_meta("ID", opt.dialog)
				$Choice.add_child(option)
				
			choice_anim.play("Open")
			last_anim = cg_anim
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
		if camera and "focus" in camera and camera.focus != null:
			camera.focus = ""
		anim.play("Close")
		await anim.animation_finished
		active = false



func start():
	if file and not active:
		input_ind.play("RESET")
		if file.resource_path == "res://assets/data/leave.json":
			leave = true
		else:
			leave = false
		box.visible = false
		box.visible_ratio = 0.0
		dialog = file.data.dialog
		line = 0
		anim.play("Open")
		next()
		active = true

func _process(delta: float) -> void:
	for i in $Choice.get_children():
		if Rect2(i.global_position, i.size).has_point(get_global_mouse_position()):
			if option_tab != i.get_index() and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				if sfx_next.stream != select_sfx:
					sfx_next.stream = select_sfx
					sfx_next.play()
				option_tab = i.get_index()  # set current choice/option based on mouse
		if i.get_index() == option_tab:  # choice/option hover active check
			i.texture = option_active
			i.position.x = move_toward(i.position.x, 180.0+i.get_index()*-60, 500*delta)
		else:
			i.texture = option_inactive
			i.position.x = move_toward(i.position.x, 240.0+i.get_index()*-60, 500*delta)
	#navigate options/choices
	if Input.is_action_just_pressed("Up"):
		if optioning:
			if sfx_next.stream != select_sfx:
				sfx_next.stream = select_sfx
			sfx_next.play()
		if option_tab > 0:
			option_tab -= 1
		else:
			option_tab = option_tab_max
	if Input.is_action_just_pressed("Down"):
		if optioning:
			if sfx_next.stream != select_sfx:
				sfx_next.stream = select_sfx
			sfx_next.play()
		if option_tab < option_tab_max:
			option_tab += 1
		else:
			option_tab = 0
	if Input.is_action_pressed("Ctrl"):
		if active:
			if instant_skip_timer < delta:
				instant_skip_timer = .1
				line += 1
				next()
				if tween:
					tween.kill()
					box.visible_ratio = 1.0
			else:
				instant_skip_timer -= delta
		
	if Input.is_action_just_pressed("Progress") and active: #click
		if active:
			if optioning:
				if optioning:
					if sfx_next.stream != confirm_sfx:
						sfx_next.stream = confirm_sfx
					sfx_next.play()
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
					else: #specifically for leaving rooms, hardcoded since only needed at one place
						RoomSwitch.switch(get_tree().current_scene.hall, get_tree().current_scene.hall_name)
			else:
				if box.visible_ratio == 1.0:
					if sfx_next.stream != next_sfx:
						sfx_next.stream = next_sfx
					sfx_next.play()
					line += 1
					input_ind.play("Next")
					next()
				else: #skip line
					if tween and dialog.size() > line:
						tween.kill()
						if last_anim:
							last_anim.seek(last_anim.current_animation_length, true)
							last_anim = null
						box.visible_ratio = 1.0
						input_ind.play("Show")

#show/hide the cursor
var old_mouse_position : Vector2
func _input(event: InputEvent) -> void:
	if optioning:
		if event is InputEventMouse:
			if event.position.distance_to(old_mouse_position) > 100: #uses position in check so it doesn't show right away when just using mouse for clicking
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event is InputEventJoypadButton or event is InputEventKey:
			old_mouse_position = get_viewport().get_mouse_position()
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
