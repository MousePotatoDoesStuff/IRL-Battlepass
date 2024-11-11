extends Control


signal DataIsChangedSignal
signal RemoveTaskSignal(is_cur: bool)
signal CopyTaskOverSignal(is_cur: bool)
@export var editable:bool
@export var is_cur:bool
var cur_editable:bool=false
var cur_taskstate:TaskState
@export var TitleNode:TextEdit
@export var DescNode:TextEdit

func _ready() -> void:
	assert(TitleNode!=null)
	assert(DescNode!=null)
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	set_curstate(TS,true)

func set_curstate(in_ts:TaskState,in_is_cur:int):
	self.cur_taskstate=in_ts
	var task=self.cur_taskstate.task
	self.is_cur=is_cur
	TitleNode.text=task.name
	DescNode.text=task.description
	$ReqDropdown.populate(task.get_res_names(false))
	$RewDropdown.populate(task.get_res_names(true))

func save():
	var task=self.cur_taskstate.task
	task.name=TitleNode.text
	task.description=DescNode.text
	# TODO save reqs and rewards

func edit_dict_open(ind:int, is_rew:bool):
	var task=self.cur_taskstate.task
	var dict=task.get_resources(is_rew)
	var key=
	$EDEWindow.set_value(dict,)
