extends Control

@export var scene: String
@onready var anim: AnimationPlayer = $Anim
@onready var scene_name_label: Label = $Scene_name
@onready var tint: ColorRect = $Tint
@onready var fade: ColorRect = $Fade

var loading = false


func switch(new_scene, scene_name):
	fade.material.set_shader_parameter("factor", 0.0)
	scene = new_scene
	scene_name_label.text = scene_name
	get_tree().paused = true
	var tween = create_tween()
	tween.tween_method(func(v): tint.material.set_shader_parameter("tint_strength", v), 0.0, 1.0, .5)
	anim.play("In")
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_method(func(v): fade.material.set_shader_parameter("factor", v), 0.0, 1.0, 1)
	await anim.animation_finished
	ResourceLoader.load_threaded_request(scene)
	loading = true

func _process(_delta: float) -> void:
	if not loading:
		return
	
	var status = ResourceLoader.load_threaded_get_status(scene)
	
	match status:
		
		ResourceLoader.THREAD_LOAD_LOADED:
			loading = false
			finish()

func finish():
	var fin_scene = ResourceLoader.load_threaded_get(scene)
	get_tree().change_scene_to_packed(fin_scene)
	anim.play("Out")
	await anim.animation_finished
	var tween = create_tween()
	tween.tween_method(func(v): tint.material.set_shader_parameter("tint_strength", v), 1.0, 0.0, .5)
	await tween.finished
	self.visible = false
	get_tree().paused = false
