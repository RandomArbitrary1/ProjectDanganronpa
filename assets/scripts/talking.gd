extends Node3D

@onready var dialog = self.get_parent().get_node("UI/Dialog")
@onready var label = self.get_parent().get_node("UI/Base/Hover_label")
var character_info = preload("res://assets/data/characters/characters.json").data

func _ready() -> void:
	for i in self.get_children():
		i.get_node("Area3D").mouse_entered.connect(func():
			if dialog.active == false:
				label.get_node("Label").text = character_info[i.name].name
				label.get_node("Anim").play("Open")
		)
		i.get_node("Area3D").mouse_exited.connect(func():
			if dialog.active == false:
				label.get_node("Anim").play("Close")
		)
		i.get_node("Area3D").input_event.connect(func(_a,event,_c,_d,_e):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				label.get_node("Anim").play("Close")
				run(i.name)
		)
		
func run(object):
	if object == "shion":
		dialog.file = load("res://assets/data/dialog/test2.json")
		dialog.start()
	elif object == "raito":
		dialog.file = load("res://assets/data/dialog/test.json")
		dialog.start()
