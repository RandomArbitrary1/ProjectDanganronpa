extends Control

var bus = AudioServer.get_bus_index("Music")

func _process(_delta: float) -> void:
	var db = db_to_linear(max(AudioServer.get_bus_peak_volume_left_db(bus, 0), AudioServer.get_bus_peak_volume_right_db(bus, 0)))
	var bounce = Vector2(.8,.8) + Vector2(db,db)/4
	self.get_node("Speaker1").scale = bounce
	self.get_node("Speaker2").scale = bounce
