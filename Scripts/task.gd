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
	in_rewards: Dictionary
):
	self.name = in_name
	self.description = in_description
	self.requirements = in_requirements
	self.rewards = in_rewards

func get_resources(rewards:bool=false):
	return self.rewards if rewards else self.requirements

func check_resources(resources:Dictionary,limit:int=-1,refund:bool=false):
	var reqtype = get_resources(refund)
	var factor=Util.check_dict_int_ratio(resources,reqtype,limit)
	return factor
