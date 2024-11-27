extends Control
signal changeSignal(new_value:int)

var taskstate:TaskState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

func test():
	var new_task=Task.new("Task not set","Cringe",{},{})
	var new_taskstate=TaskState.new(new_task,2,10,5)
	set_progress_display(new_taskstate)

func set_progress_display(new_taskstate:TaskState):
	self.taskstate=new_taskstate
	var relprogress:float=self.taskstate.get_cur_ratio()
	var minprogress:float=self.taskstate.get_min_ratio()
	$ProgressBar.set_progress(relprogress,minprogress)
	$ProgressNumber.text=self.taskstate.get_ratio_text()

func set_progress(val:int):
	val=max(val,taskstate.min_amount)
	val=min(val,taskstate.max_amount)
	if changeSignal.get_connections().is_empty():
		self.taskstate.cur_amount=val
		set_progress_display(self.taskstate)
		return
	changeSignal.emit(val)

func button_use():
	var delta=int($CustomInput.text)
	var val=self.taskstate.cur_amount+delta
	set_progress(val)

func button_refund():
	var delta=int($CustomInput.text)
	var val=self.taskstate.cur_amount-delta
	set_progress(val)

func button_set():
	var delta=int($CustomInput.text)
	set_progress(delta)
