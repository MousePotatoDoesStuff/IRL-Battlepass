extends JSONReusable
class_name TaskState

var task:Task
var min_amount: int
var cur_amount: int
var max_amount: int
var task_frame=null

func _init(
	in_task:Task,
	in_min_amount: int,
	in_max_amount: int,
	in_cur_amount: int=-1,
	in_id: int=-1
):
	self.task=in_task
	self.min_amount = in_min_amount
	self.max_amount = in_max_amount
	self.cur_amount = {-1:self.min_amount}.get(in_cur_amount,in_cur_amount)
	self.id=in_id

static func process_from_raw(raw: Dictionary, existing:Dictionary={}):
	var vars=Util.check_dict_values(raw,['task','min','max','cur'])
	if vars == null:
		return null
	assert(vars[0] is Dictionary)
	print(typeof(vars[1]), typeof(1.0))
	for i in range(1,4):
		if vars[i] is float:
			vars[i]=int(vars[i])
		assert(vars[i] is int, str(vars[i]))
	var task=Task.from_raw(vars[0], existing)
	var ID=raw.get('id',-1)
	var res=TaskState.new(task,vars[1],vars[2],vars[3],ID)
	return res

static func from_raw(raw: Dictionary, existing: Dictionary={}):
	var res=from_raw_base(raw,existing,'TaskState')
	return res

static func from_array(rawarray: Array)->Array[TaskState]:
	var resarray:Array[TaskState]=[]
	for raw in rawarray:
		var res=from_raw(raw)
		if res==null:
			continue
		resarray.append(res)
	return resarray

static func from_dict(rawdict: Dictionary):
	var resdict={}
	for key in rawdict:
		var raw=rawdict[key]
		var res=from_raw(raw)
		if res==null:
			continue
		resdict[key]=res
	return resdict

func to_raw()->Dictionary:
	var res={
		'task': self.task.to_raw(),
		'min': self.min_amount,
		'max': self.max_amount,
		'cur': self.cur_amount
	}
	return res

static func to_array(array: Array[TaskState]):
	var resarray=[]
	for obj in array:
		var res=obj.to_raw()
		if res==null:
			continue
		resarray.append(res)
	return resarray
	

static func to_dict(dict: Dictionary):
	var resdict={}
	for key in dict:
		var obj=dict[key]
		var res=obj.to_raw()
		if res==null:
			continue
		resdict[key]=res
	return resdict

func get_cur_ratio()->float:
	return 1.0*self.cur_amount/self.max_amount

func get_min_ratio()->float:
	return 1.0*self.min_amount/self.max_amount

func get_ratio_text()->String:
	return "%d/%d" % [self.cur_amount,self.max_amount]

func apply_resources(resources:Dictionary,limit:int=-1):
	var ran=self.max_amount-self.cur_amount
	limit=limit if limit in range(ran) else ran
	var factor=self.task.check_resources(resources,limit,false)
	Util.add_dict_int_values(resources,self.task.requirements,-factor)
	Util.add_dict_int_values(resources,self.task.rewards,factor)
	self.cur_amount+=factor
	return limit

func refund_resources(resources:Dictionary,limit:int=-1):
	var ran=self.cur_amount-self.min_amount
	limit=limit if limit in range(ran) else ran
	var factor=self.task.check_resources(resources,limit,true)
	Util.add_dict_int_values(resources,self.task.requirements,factor)
	Util.add_dict_int_values(resources,self.task.rewards,-factor)
	self.cur_amount-=factor
	return limit
