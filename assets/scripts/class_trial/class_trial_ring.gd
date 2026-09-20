extends Node3D
#@export var podium_amount:int = 16
var person_spots = ["shion","nori","yuito","raito","ayuka","rikuno","tenga","naeri"]
@onready var podiums: Node3D = $podiums
var data = JsonParse.load_json("characters/characters.json")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up()
	
func set_up():
	for podium in podiums.get_children():
		var index = podium.get_index()
		if index < person_spots.size():
			var person_data = data[person_spots[index]]
			var person_sprite_path = person_data["sprites"]
			podium.place_person(person_spots[index])
			podium.swap(person_sprite_path["neutral"])
