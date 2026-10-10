extends Node

var data = preload("res://assets/data/game/data.json").data.character_data
const character = preload("res://assets/objects/characters/character.tscn")

func _ready() -> void:
	spawn_all()

func spawn_all():
	for key in data:
		var chr = data[key]
		if chr.room == get_tree().current_scene.scene_file_path:
			spawn(key, chr.room, Vector3(chr.position.x,chr.position.y,chr.position.z), chr.dialog, chr.expression)
	

func spawn(chr, room, pos, dialog, expression):
	var characters = get_tree().get_first_node_in_group("Characters_interact")
	data[chr].room = room
	data[chr].position.x = pos.x
	data[chr].position.y = pos.y
	data[chr].position.z = pos.z
	data[chr].dialog = dialog
	if !characters:
		return
	if room == get_tree().current_scene.scene_file_path:
		var new_char = characters.find_child(chr)
		if not new_char:
			new_char = character.instantiate()
			new_char.name = chr
			new_char.character = chr
			new_char.expression = expression
			characters.add_child(new_char)
		if ResourceLoader.exists(dialog):
			new_char.dialog = dialog
		new_char.position = pos
		new_char.get_node("Anim").play("Enter")
		await new_char.get_node("Anim").animation_finished
	else:
		var old_char = characters.find_child(chr)
		if old_char:
			old_char.get_node("Anim").play("Leave")
			await old_char.get_node("Anim").animation_finished
			old_char.queue_free()
