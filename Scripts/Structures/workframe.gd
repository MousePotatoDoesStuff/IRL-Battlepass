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
	var raw_curtasks:Array=raw.get('current',[])
	var raw_periodical:Dictionary=raw.get('periodical',{})
	var raw_available:Array=raw.get('available',[])
	var raw_inventory:Dictionary=raw.get('inventory',{})
	var raw_targets:Dictionary=raw.get('targets',{})
	
	assert(raw_curtasks is Array)
	assert(raw_periodical is Dictionary)
	assert(raw_available is Array)
	assert(raw_inventory is Dictionary)
	assert(raw_targets is Dictionary)
	
	var periodicals={}
	for key in raw_periodical:
		var val=raw_periodical[key]
		periodicals[key]=WorkFrame.from_raw(val)
	
	var temp:Array[TaskState]=TaskState.from_array(raw_curtasks)
	var curtasks:Array[TaskState]=temp
	var available:Array[TaskState]=TaskState.from_array(raw_available)
	return WorkFrame.new(curtasks, periodicals, available, raw_inventory, raw_targets)

func to_raw():
	var tempres={}
	for key in self.periodical_tasks:
		tempres[key]=self.periodical_tasks[key].to_raw()
	var res={
		'current'		: TaskState.to_array(self.current_tasks),
		'periodical'	: tempres,
		'available'		: TaskState.to_array(self.current_tasks),
		'inventory'		: self.inventory.duplicate(),
		'targets'		: self.targets.duplicate()
	}
	return res

func get_cur_tasks():
	return self.current_tasks.duplicate()

func get_cur_task_names()->Array[String]:
	var names:Array[String]=[]
	for taskstate:TaskState in self.current_tasks:
		var task:Task=taskstate.task
		var name=task.name
		names.append(name)
	return names

func get_avail_tasks():
	return self.available_tasks.duplicate()

func insert_task(ind:int, task:Task):
	if ind<0:
		ind=0
	ind=min(ind,len(self.current_tasks))
	self.current_tasks.insert(ind,task)
	return

func remove_task(ind:int):
	if ind<0:
		ind=0
	ind=min(ind,len(self.current_tasks)-1)
	self.current_tasks.remove_at(ind)
	return
