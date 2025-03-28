extends Control

var hovering:bool=false
func _ready() -> void:
	setProgress(0.5,0.1)


func setProgress(done:float,locked:float):
	var done_size=Vector2(done,1.0)*$bg.size
	var locked_size=Vector2(locked,1.0)*$bg.size
	$done.set_deferred('size',done_size)
	$locked.set_deferred('size',locked_size)


func hover() -> void:
	self.hovering=true
	self._process(0)


func unhover() -> void:
	self.hovering=false
