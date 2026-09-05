extends Node3D
#@export var podium_amount:int = 16
var person_spots = ["shion","nori","yuito","raito","ayuka"]
@onready var podiums: Node3D = $podiums
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up()
	
func set_up():
	for podium in podiums.get_children():
		pass
		#if person_spots[podium.get_index()]:
			#podium.place_person(person_spots[podium.get_index()])
