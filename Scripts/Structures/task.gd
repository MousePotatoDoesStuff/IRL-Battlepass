extends JSONReusable
class_name Task

var name: String
var description: String
var requirements: Dictionary
var rewards: Dictionary

func _init(
	in_name: String,
	in_description: String,
	in_requirements: Dictionary,
	in_rewards: Dictionary,
	in_id: int=0
):
	self.name = in_name
	self.description = in_description
	self.requirements = in_requirements
	self.rewards = in_rewards
	self.id = in_id

static func process_from_raw(raw: Dictionary, existing: Dictionary):
	var vars=Util.check_dict_values(raw,['name','desc','reqs','rews'])
	if vars == null:
		return null
	assert(vars[0] is String)
	assert(vars[1] is String)
	assert(vars[2] is Dictionary)
	assert(vars[3] is Dictionary)
	var ID=raw.get('id',0)
	var res=Task.new(vars[0],vars[1],vars[2],vars[3],ID)
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

static func get_class_name():
	return "Task"

func process_to_raw(existing: Dictionary={})->Dictionary:
	var raw={
		'name':self.name,
		'desc':self.description,
		'reqs':self.requirements,
		'rews':self.rewards,
		'id':self.id
	}
	return raw

func get_resources(rewards:bool=false):
	return self.rewards if rewards else self.requirements

func check_resources(resources:Dictionary,limit:int=-1,refund:bool=false):
	var reqtype = get_resources(refund)
	var factor=Util.check_dict_int_ratio(resources,reqtype,limit)
	return factor
