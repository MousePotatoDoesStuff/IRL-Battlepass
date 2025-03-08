extends Control
class_name MenuMode

signal quicksave

var data:Dictionary={}

@export var menu_name:String="Unnamed"
func on_open(_data:Dictionary):
	show()
	return

func on_close(_data:Dictionary):
	hide()
	return

func save_data(data_storage:Dictionary={})->Dictionary:
	return data_storage
