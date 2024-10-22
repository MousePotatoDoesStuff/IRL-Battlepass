extends Control


signal DataIsChangedSignal
signal RemoveTaskSignal(is_cur: bool)
signal CopyTaskOverSignal(is_cur: bool)
@export var editable:bool
@export var is_cur:bool
var cur_editable:bool=false
var cur_taskstate:TaskState
var cur_inventory:Dictionary

func _ready() -> void:
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	var A={"Hi":1}
	set_curstate(TS,A,true)

func set_curstate(in_ts:TaskState,in_inv:Dictionary,in_is_cur:int):
	self.cur_taskstate=in_ts
	self.cur_inventory=in_inv
	self.is_cur=is_cur
	$Title.text=cur_taskstate.task.name
	$Description.text=cur_taskstate.task.description
	$ProgressControl.set_progress_display(cur_taskstate)
	$InventoryDisplay.display_data(in_inv,cur_taskstate.task.requirements)
	$RewardDisplay.display_data(in_inv,cur_taskstate.task.rewards)

func process_change(new_value:int):
	var delta=new_value-cur_taskstate.cur_amount
	if delta==0:
		return
	var used_value
	if delta>0:
		used_value=cur_taskstate.apply_resources(cur_inventory,delta)
	else:
		used_value=cur_taskstate.refund_resources(cur_inventory,-delta)
	print(delta,cur_inventory)
	set_curstate(cur_taskstate,cur_inventory)
	DataIsChangedSignal.emit()

func pass_remove_task():
	RemoveTaskSignal.emit(self.is_cur)
	DataIsChangedSignal.emit()

func pass_copy_over():
	CopyTaskOverSignal.emit(self.is_cur)
	DataIsChangedSignal.emit()
