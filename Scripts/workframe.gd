extends Object
class_name WorkFrame

var current_tasks:Array[TaskState]
var periodical_tasks:Dictionary
var available_tasks:Array[TaskState]
var inventory:Dictionary
var targets:Dictionary

func _init(
		in_current:Array[TaskState]=[], in_periodical:Dictionary={}, in_available:Array[TaskState]=[],
		in_inventory:Dictionary={}, in_targets:Dictionary={}
	) -> void:
	self.current_tasks=in_current
	self.periodical_tasks=in_periodical
	self.available_tasks=in_available
	self.inventory=in_inventory
	self.targets=in_targets

func get_cur_tasks():
	return self.current_tasks.duplicate()

func get_cur_task_names()->Array[String]:
	var names:Array[String]=[]
	for task in self.current_tasks:
		names.append(task.task.name)
	return names

func get_avail_tasks():
	return self.available_tasks.duplicate()
