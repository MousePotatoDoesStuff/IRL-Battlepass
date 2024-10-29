extends Control


signal DataIsChangedSignal
signal RemoveTaskSignal(is_cur: bool)
signal CopyTaskOverSignal(is_cur: bool)
@export var editable:bool
@export var is_cur:bool
var cur_editable:bool=false
var cur_taskstate:TaskState

func _ready() -> void:
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	set_curstate(TS,true)

func set_curstate(in_ts:TaskState,in_is_cur:int):
	self.cur_taskstate=in_ts
	var task=self.cur_taskstate.task
	self.is_cur=is_cur
	$Title.text=cur_taskstate.task.name
	$Description.text=cur_taskstate.task.description
	$ReqDropdown.populate(task.get_res_names(false))
	$RewDropdown.populate(task.get_res_names(true))
	
