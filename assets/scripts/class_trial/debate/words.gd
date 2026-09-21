extends Control
@onready var debate_roulette: Control = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !debate_roulette.state == "debate":
		return
	
func word_init():
	for w in get_children():
		w.queue_free()

	var label = RichTextLabel.new()
	label.mouse_filter = Control.MOUSE_FILTER_STOP
	label.bbcode_enabled = true
	label.text = str(debate_roulette.dialog_data[debate_roulette.dialog_index]["content"])
	label.theme = debate_roulette.words_theme
	label.fit_content = true
	label.custom_minimum_size = Vector2(1000, 0)
	add_child(label)
	label.position = Vector2(625,464)
	label.pivot_offset = label.size / 2 # Offset works after add_child
	label.gui_input.connect(_on_label_gui_input)
	label.mouse_entered.connect(_on_label_hover)
	
func _on_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Label clicked")
		
func _on_label_hover():
	print("BLABLBALABLLBLBLALBLABLLB")
	
