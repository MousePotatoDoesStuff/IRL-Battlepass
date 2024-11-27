extends Control

func _ready() -> void:
	set_progress(0.5,0.1)


func set_progress(done:float,locked:float):
	var done_size=Vector2(done,1.0)*$bg.size
	var locked_size=Vector2(locked,1.0)*$bg.size
	$done.set_deferred('size',done_size)
	$locked.set_deferred('size',locked_size)
