extends JSONReusable
class_name TaskState

var task:Task
var min_amount: int
var cur_amount: int
var max_amount: int
var task_frame:WorkFrame=null

func _init(
	in_task:Task,
	in_min_amount: int,
	in_max_amount: int,
	in_cur_amount: int=-1,
	in_id: int=-1,
	in_frame:WorkFrame=null
):
	assert(in_task is Task)
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
	var ID=raw.get('id',-1)
	var res=TaskState.new(null,vars[1],vars[2],vars[3],ID)
	return res

static func from_raw(raw: Dictionary, existing: Dictionary):
	"""
	Create function from processed JSON.
	"""
	var classname=get_class_name()
	var old:Task=check_for(raw, existing, classname)
	if old != null:
		return old
	var res:JSONReusable=process_from_raw(raw, existing)
	var ID=raw.get('id',-1)
	set_new(existing,classname,ID,res)
	raw['id']=res.id
	return res

func postprocess(complex_values: Array):
	self.task=complex_values[0]
	self.task_frame=complex_values[1]
	assert(false,"Postprocessing function not implemented!")

static func get_class_name():
	return "TaskState"

static func from_array(rawarray: Array, existing:Dictionary)->Array[TaskState]:
	var resarray:Array[TaskState]=[]
	for raw in rawarray:
		var res=from_raw(raw, existing)
		if res==null:
			continue
		assert(res is TaskState)
		resarray.append(res)
	return resarray

static func from_dict(rawdict: Dictionary, existing:Dictionary):
	var resdict={}
	for key in rawdict:
		var raw=rawdict[key]
		var res=from_raw(raw, existing)
		if res==null:
			continue
		resdict[key]=res
	return resdict

func process_to_raw(existing: Dictionary)->Dictionary:
	var tf=null
	if self.task_frame!=null:
		tf=self.task_frame.to_raw(existing)
	var res={
		'task': self.task.to_raw(),
		'min': self.min_amount,
		'max': self.max_amount,
		'cur': self.cur_amount,
		'workframe':tf
	}
	return res

static func to_array(array: Array[TaskState], existing:Dictionary):
	var resarray=[]
	for obj in array:
		var res=obj.to_raw(existing)
		if res==null:
			continue
		resarray.append(res)
	return resarray
	

static func to_dict(dict: Dictionary, existing:Dictionary):
	var resdict={}
	for key in dict:
		var obj=dict[key]
		var res=obj.to_raw(existing)
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
