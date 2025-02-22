extends Control

func _ready():
	update_size()

func _process(delta):
	update_size()

func update_size():
	var parent:Control=get_parent()
	assert(parent!=null)
	var parent_size=parent.size
	if parent_size.y<1:
		return
	var target_aspect_ratio = parent_size.x / parent_size.y
	size.x = size.y*target_aspect_ratio
	scale=parent.size/size


func _on_main_scene_resized() -> void:
	pass # Replace with function body.
