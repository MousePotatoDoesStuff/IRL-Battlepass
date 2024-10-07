extends Control


@export var editable:bool
var main_data_struct={}
var cur_editable:bool=false
var cur_workframe:WorkFrame
var cur_inventory:Dictionary
var tasks:Dictionary
var workframes:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_data()
	var raw_test_data=JSON.stringify(main_data_struct,"  ")
	print(raw_test_data)

func init_data():
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	var A={"Hi":1}
	var B={"Nice 2 meet u":1}
	var TSA:Array[TaskState]=[TS]
	var cur_workframe=WorkFrame.new(TSA,{},[],A,B)
	set_workframe(cur_workframe)
	save_data()

func load_data(data:Dictionary):
	self.main_data_struct=data
	if 'cur_workframe' not in data:
		init_data()
	self.cur_editable=data.get('editable',false)
	var raw_workframe:Dictionary=data['cur_workframe']
	self.cur_workframe=WorkFrame.from_raw(raw_workframe)
	self.cur_inventory=cur_workframe.inventory
	var raw_tasks:Dictionary=data.get('tasks',[])
	self.tasks=TaskState.from_dict(raw_tasks)
	var raw_workframes:Dictionary=data.get('workframes',[])
	self.workframes={}
	for key in raw_workframes:
		var rawframe=raw_workframes[key]
		var frame=WorkFrame.from_raw(rawframe)
		self.workframes[key]=frame
	return

func save_data(data_storage=null):
	var data:Dictionary=data_storage if data_storage is Dictionary else self.main_data_struct
	data['editable']=self.cur_editable
	var raw_main=self.cur_workframe.to_raw()
	data['cur_workframe']=raw_main
	var raw_tasks=TaskState.to_dict(self.tasks)
	data['tasks']=raw_tasks
	var raw_workframes={}
	for key in self.workframes:
		var frame:WorkFrame=self.workframes[key]
		var rawframe=frame.to_raw()
		raw_workframes[key]=rawframe
	data['workframes']=raw_workframes
	return data

func set_task_list():
	var texts:Array[String]=cur_workframe.get_cur_task_names()
	$"Task List".populate(texts)

func set_workframe(workframe:WorkFrame):
	self.cur_workframe=workframe
	self.set_task_list()
