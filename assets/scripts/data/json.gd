extends Node

func _ready() -> void:
	pass

func load_json(path:String): # ALREADY LOOKS INSIDE "data" folder as root, add path like: "/dialog/test.json"
	var combined = "res://assets/data/" + path + ".json"
	var file = FileAccess.open(combined,FileAccess.READ)
	
	if file == null: # file doesnt exist
		print("FILE doesn't exist, is path or FOLDER PATH correct?/JSON PARSE ERROR")
		push_error("FILE doesn't exist, is path or FOLDER PATH correct?")
		return null
		
	var text = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(text)
	if error != OK:
		push_error(
			"JSON error in %s at line %d: %s"
			% [
				combined,
				json.get_error_line(),
				json.get_error_message()
			]
		)
		return null
	return json.data
