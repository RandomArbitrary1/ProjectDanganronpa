@tool
extends Camera3D

@export_tool_button("Take Screenshot") var take_screenshot_action = _take_screenshot
@export var output_path: String = "user://screenshot.png"
@export var resolution: Vector2i = Vector2i(1920, 1080)

func _take_screenshot() -> void:
	if resolution == Vector2i(0, 0):
		resolution = Vector2i(1920, 1080)
	
	var vp: SubViewport = SubViewport.new()
	if not is_instance_valid(vp):
		push_error("SubViewport creation failed.")
		return
	
	vp.set_size(resolution)
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(vp)
	
	var cam: Camera3D = duplicate() as Camera3D
	if not is_instance_valid(cam):
		push_error("Camera duplication failed.")
		vp.queue_free()
		return
	
	vp.add_child(cam)
	
	await RenderingServer.frame_post_draw
	
	var image := vp.get_texture().get_image()
	if image:
		image.flip_y()
		image.save_png(output_path)
		print("Saved: ", ProjectSettings.globalize_path(output_path))
	
	vp.queue_free()
