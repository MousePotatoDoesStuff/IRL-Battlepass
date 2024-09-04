extends Control


@export var editable:bool
var cur_editable:bool=false
var cur_workframe:WorkFrame
var cur_inventory:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	var A={"Hi":1}
	var B={"Nice 2 meet u":1}
	var TSA:Array[TaskState]=[TS]
	var cur_workframe=WorkFrame.new(TSA,{},[],A,B)
	set_workframe(cur_workframe)

func set_task_list():
	var texts:Array[String]=cur_workframe.get_cur_task_names()
	$"Task List".populate(texts)

func set_workframe(workframe:WorkFrame):
	self.cur_workframe=workframe
	self.set_task_list()
