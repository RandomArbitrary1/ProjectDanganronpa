extends Node3D

@onready var dialog = self.get_parent().get_node("UI/Dialog")

func _ready() -> void:
	self.get_node("Person1/Area3D").input_event.connect(func(_a,event,_c,_d,_e):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dialog.file = load("res://assets/data/dialog/test.json")
			dialog.start()
	)
	self.get_node("Person2/Area3D").input_event.connect(func(_a,event,_c,_d,_e):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dialog.file = load("res://assets/data/dialog/test2.json")
			dialog.start()
	)
