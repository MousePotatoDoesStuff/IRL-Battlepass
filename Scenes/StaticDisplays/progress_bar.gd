extends Control

func _ready() -> void:
	set_progress(0.5,0.1)


func set_progress(done:float,locked:float):
	$done.size=Vector2(done,1.0)*$bg.size
	$locked.size=Vector2(locked,1.0)*$bg.size
