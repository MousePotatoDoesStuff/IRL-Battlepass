extends Object
class_name WorkFrame

var current_tasks:Array[Task]
var periodical_tasks:Dictionary
var available_tasks:WorkFrame
var inventory:Dictionary
var targets:Dictionary

func _init(
		in_current:Array[Task]=[], in_periodical:Dictionary={}, in_available:Array[Task]=[],
		in_inventory:Dictionary={}, in_targets:Dictionary={}
	) -> void:
	self.current_tasks=current_tasks
	self.periodical_tasks=periodical_tasks
	self.available_tasks=available_tasks
	self.inventory=in_inventory
	self.targets=in_targets

func get_cur_tasks():
	return self.current_tasks.duplicate()

func get_avail_tasks():
	return self.available_tasks.duplicate()
