extends Node3D
#@export var podium_amount:int = 16
var person_spots = {1:"shion",2:"teraua",3:"asdf",4:"asdw"}
@onready var podiums: Node3D = $podiums
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up()
	
func set_up():
	for podium in podiums.get_children():
		print(podium)
