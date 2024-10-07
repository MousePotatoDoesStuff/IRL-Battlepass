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

static func from_raw(raw: Dictionary):
	var vars=Util.check_dict_values(raw,['current','periodical','available','inventory','targets'])
	if vars == null:
		return null
	assert(vars[0] is Array)
	assert(vars[1] is Dictionary)
	assert(vars[2] is Array)
	assert(vars[3] is Dictionary)
	assert(vars[4] is Dictionary)
	var periodicals={}
	for key in vars[1]:
		var val=vars[1][key]
		periodicals[key]=WorkFrame.from_raw(val)
	var res=[
		TaskState.from_array(vars[0]),
		periodicals,
		TaskState.from_array(vars[2]),
		vars[3],
		vars[4]
	]
	return WorkFrame.new(res[0], res[1], res[2], res[3], res[4])

func to_raw():
	var tempres={}
	for key in self.periodical_tasks:
		tempres[key]=self.periodical_tasks[key].to_raw()
	var res={
		'current'		: TaskState.to_array(self.current_tasks),
		'periodical'	: tempres,
		'available'		: TaskState.to_array(self.current_tasks),
		'inventory'		: self.inventory,
		'targets'		: self.targets
	}
	return res

func get_cur_tasks():
	return self.current_tasks.duplicate()

func get_cur_task_names()->Array[String]:
	var names:Array[String]=[]
	for task in self.current_tasks:
		names.append(task.task.name)
	return names

func get_avail_tasks():
	return self.available_tasks.duplicate()
