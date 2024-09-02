extends Object
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
	in_cur_amount: int=-1
):
	self.task=in_task
	self.min_amount = in_min_amount
	self.max_amount = in_max_amount
	self.cur_amount = {-1:self.min_amount}.get(in_cur_amount,in_cur_amount)

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
