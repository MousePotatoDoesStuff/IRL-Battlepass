extends Control
class_name MenuMode

@export var menu_name:String=""
func on_open(_data:Dictionary):
	show()
	return

func on_close(_data:Dictionary):
	hide()
	return
