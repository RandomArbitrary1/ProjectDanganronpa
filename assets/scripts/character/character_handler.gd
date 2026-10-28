extends Node

var data = GameData.data.character_data
const character = preload("res://assets/objects/characters/character.tscn")

func _ready() -> void:
	spawn_all()

func spawn_all():
	for key in data:
		for i in data[key].size():
			var chr = data[key][i]
			if chr.room == get_tree().current_scene.scene_file_path:
				spawn(key, chr.room, Vector3(chr.position.x,chr.position.y,chr.position.z), chr.dialog, chr.expression, true)
	

#TODO mk -- plz make room var be list not string thx
func spawn(chr, room, pos, dialog, expression, active):
	var characters = get_tree().get_first_node_in_group("Characters_interact")
	for i in data[chr].size(): #remove/add room data
		var room_data = data[chr][i]
		if active and not room_data.has(room):
			room_data.room = room
			room_data.position.x = pos.x
			room_data.position.y = pos.y
			room_data.position.z = pos.z
			room_data.dialog = dialog
		elif not active and room_data.has(room):
			data[chr].remove_at(i)
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
		new_char.global_position = pos
		new_char.position.y = pos.y
		new_char.get_node("Anim").play("Enter")
		await new_char.get_node("Anim").animation_finished
	else:
		var old_char = characters.find_child(chr)
		if old_char:
			old_char.get_node("Anim").play("Leave")
			await old_char.get_node("Anim").animation_finished
			old_char.queue_free()
