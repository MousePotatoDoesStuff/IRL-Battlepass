extends Control


signal DataIsChangedSignal
signal CopyTaskOverSignal(is_cur: bool)
signal ExitEditSignal(is_cur:bool, task: TaskState)
@export var editable:bool
@export var is_cur:bool
var cur_editable:bool=false
var cur_taskstate:TaskState
@export var TitleNode:TextEdit
@export var DescNode:TextEdit
@export var ReqEditor:InventoryEditor
@export var RewEditor:InventoryEditor

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
	ReqEditor.populate(task.requirements)
	RewEditor.populate(task.rewards)

func save():
	var task=self.cur_taskstate.task
	task.name=TitleNode.text
	task.description=DescNode.text
	# TODO save reqs and rewards
	DataIsChangedSignal.emit()
