extends Control

var analyzer = AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	pass
	#analyzer = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Music"), 0)
	#print(analyzer)

func _process(_delta: float) -> void:
	pass
	#analyzer = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Music"), 0)
	#print(analyzer.get_magnitude_for_frequency_range(20.0, 60.0))
