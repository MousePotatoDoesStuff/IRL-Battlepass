extends Object
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
):
	self.name = in_name
	self.description = in_description
	self.requirements = in_requirements
	self.rewards = in_rewards

static func from_raw(raw: Dictionary):
	var vars=Util.check_dict_values(raw,['name','desc','reqs','rews'])
	if vars == null:
		return null
	assert(vars[0] is String)
	assert(vars[1] is String)
	assert(vars[2] is Dictionary)
	assert(vars[3] is Dictionary)
	var ID=raw.get('id',0)
	var res=Task.new(vars[0],vars[1],vars[2],vars[3])
	return res

func to_raw()->Dictionary:
	var raw={
		'name':self.name,
		'desc':self.description,
		'reqs':self.requirements,
		'rews':self.rewards,
	}
	return raw

func get_resources(rewards:bool=false):
	return self.rewards if rewards else self.requirements

func get_res_names(rewards:bool=false):
	var src = self.rewards if rewards else self.requirements
	var res:Array[String]=[]
	for e in src:
		res.append(e)
	return res

func check_resources(resources:Dictionary,limit:int=-1,refund:bool=false):
	var reqtype = get_resources(refund)
	var factor=Util.check_dict_int_ratio(resources,reqtype,limit)
	return factor
