extends Control

@export var file: String
@export var active: bool
@onready var box = self.get_node("Bar/Dialog")
@onready var anim = self.get_node("Anims")
@onready var nameplate = self.get_node("Bar/Name")

var dialog = null
var line = 0


func next():
	if line < dialog.size():
		if dialog[line][0] == "Text":
			nameplate.get_node("Label").text = dialog[line][1]
			box.text = dialog[line][4]
			var tween: Tween = create_tween()
			tween.tween_property(box, "visible_ratio", 1.0, dialog[line][4].length()*dialog[line][3]).from(0.0)
	else:
		active = false
		anim.play("Close")

func start():
	if file != "" and not active:
		#dialog = load(file).data
		dialog = load("res://assets/data/dialog/test.json").data
		line = 0
		anim.play("Open")
		next()
		active = true
		

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Progress") and active and box.visible_ratio == 1.0:
		line += 1
		next()
		
