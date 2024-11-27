extends Control


signal DataIsChangedSignal
# signal CopyTaskOverSignal(is_cur: bool) # TODO implement task copying
signal ExitEditSignal(is_cur:bool, task: TaskState)
@export var is_cur:bool
var changedetect_lock:bool=false
var cur_taskstate:TaskState
@export var TitleNode:TextEdit
@export var DescNode:TextEdit
@export var ReqEditor:InventoryEditor
@export var RewEditor:InventoryEditor

func _ready() -> void:
	assert(TitleNode!=null)
	assert(DescNode!=null)
	return

func test():
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	set_curstate(TS,true)

func set_curstate(in_ts:TaskState,in_is_cur:int):
	self.changedetect_lock=true
	self.cur_taskstate=in_ts
	var task=self.cur_taskstate.task
	self.is_cur=in_is_cur
	TitleNode.text=task.name
	DescNode.text=task.description
	ReqEditor.populate(task.requirements)
	RewEditor.populate(task.rewards)
	$VBoxContainer/Min.set_value(in_ts.min_amount)
	$VBoxContainer/Max.set_value(in_ts.max_amount)
	$VBoxContainer/Cur.set_value(in_ts.cur_amount)
	self.changedetect_lock=false

func save():
	if changedetect_lock:
		return
	if cur_taskstate == null:
		return
	var task=self.cur_taskstate.task
	task.name=TitleNode.text
	task.description=DescNode.text
	self.cur_taskstate.min_amount=$VBoxContainer/Min.get_value()
	self.cur_taskstate.max_amount=$VBoxContainer/Max.get_value()
	self.cur_taskstate.cur_amount=$VBoxContainer/Cur.get_value()
	DataIsChangedSignal.emit()

func close():
	ExitEditSignal.emit(self.is_cur,self.cur_taskstate)
