extends Control
signal changeSignal(new_value:int)

var taskstate:TaskState
@export var colors:Array[Color]=[Color.BLUE,Color.GREEN,Color.YELLOW]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test()
	return

func test():
	var new_task=Task.new("Task not set","Cringe",{},{})
	var new_taskstate=TaskState.new(new_task,2,10,5)
	setProgressDisplay(new_taskstate)

func setProgressDisplay(new_taskstate:TaskState):
	self.taskstate=new_taskstate
	var relprogress:float=self.taskstate.get_cur_ratio()
	var minprogress:float=self.taskstate.get_min_ratio()
	var units:Array[int]=[new_taskstate.min_amount,new_taskstate.cur_amount,new_taskstate.max_amount]
	$TimelineBar.displayUnits(
		units,colors,false
	)
	$ProgressNumber.text=self.taskstate.get_ratio_text()

func setProgress(val:int):
	val=max(val,taskstate.min_amount)
	val=min(val,taskstate.max_amount)
	if changeSignal.get_connections().is_empty():
		self.taskstate.cur_amount=val
		setProgressDisplay(self.taskstate)
		return
	changeSignal.emit(val)

func button_use():
	var delta=int($CustomInput.text)
	var val=self.taskstate.cur_amount+delta
	setProgress(val)

func button_refund():
	var delta=int($CustomInput.text)
	var val=self.taskstate.cur_amount-delta
	setProgress(val)

func button_set():
	var delta=int($CustomInput.text)
	setProgress(delta)

func bar_feedback(bar_res:int):
	self.setProgress(bar_res)
