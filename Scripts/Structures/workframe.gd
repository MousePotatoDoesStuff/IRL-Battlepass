extends JSONReusable
class_name WorkFrame

var current_tasks:Array[TaskState]
var periodical_tasks:Dictionary
var available_tasks:Array[TaskState]
var inventory:Dictionary
var targets:Dictionary

static func get_class_name():
	return "WorkFrame"

func _init(
		in_current:Array[TaskState]=[], in_periodical:Dictionary={}, in_available:Array[TaskState]=[],
		in_inventory:Dictionary={}, in_targets:Dictionary={},
		in_id=-1
	) -> void:
	self.current_tasks=in_current
	self.periodical_tasks=in_periodical
	self.available_tasks=in_available
	self.inventory=in_inventory
	self.targets=in_targets
	self.id=in_id

static func process_from_raw(raw: Dictionary, existing:Dictionary={}):
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
		periodicals[key]=WorkFrame.from_raw(val, existing)
	var temp:Array[TaskState]=TaskState.from_array(vars[0], existing)
	var curtasks:Array[TaskState]=temp
	var available:Array[TaskState]=TaskState.from_array(vars[2], existing)
	return WorkFrame.new(curtasks, periodicals, available, vars[3], vars[4])

static func from_raw(raw: Dictionary, existing: Dictionary):
	"""
	Create function from processed JSON.
	"""
	var classname=get_class_name()
	var old:Task=check_for(raw, existing, classname)
	if old != null:
		return old
	var res=process_from_raw(raw, existing)
	var ID=raw.get('id',0)
	set_new(existing,classname,ID,res)
	raw['id']=ID+1
	return res

func process_to_raw(existing):
	var tempres={}
	for key in self.periodical_tasks:
		tempres[key]=self.periodical_tasks[key].to_raw()
	var res={
		'current'		: TaskState.to_array(self.current_tasks, existing),
		'periodical'	: tempres,
		'available'		: TaskState.to_array(self.current_tasks, existing),
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
