extends MenuMode


signal save_and_exit


@export var editable:bool
@export var ex_task_display:Control
@export var ex_av_task_list:Control
@export var ex_cur_task_list:Control
@export var ex_subframe_list:Control
@export var ex_inv_disp:InventoryDisplay
var existing=null
var main_data_struct={}
var cur_editable:bool=false
var cur_workframe:WorkFrame
var cur_inventory:Dictionary
var tasks:Array[TaskState]
var workframes:Dictionary

var cur_task_ind:int
var is_cur_in_workframe:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return
	init_data()
	var raw_test_data=JSON.stringify(main_data_struct,"  ")
	print(cur_workframe.current_tasks)

func init_data():
	var T=Task.new(
		"HelloTask","Hello!",{"Hi":1},{"Nice 2 meet u":1}
	)
	var TS=TaskState.new(T,1,4,2)
	var A={"Hi":1}
	var B={"Nice 2 meet u":1}
	var TSA:Array[TaskState]=[TS]
	cur_workframe=WorkFrame.new(TSA,{},[],A,B)
	var existing={}
	print(cur_workframe.to_raw(existing))
	print(existing)
	save_data()

func on_open(data:Dictionary, existing:Dictionary):
	load_data(data, existing)
	show()
	return

func on_close(data:Dictionary, existing:Dictionary):
	save_data(data, existing)
	hide()
	return

func load_data(data:Dictionary, existing:Dictionary={}):
	self.existing=existing
	self.main_data_struct=data
	if 'cur_workframe' not in data:
		init_data()
	
	self.cur_editable=data.get('editable',false)
	
	var raw_workframe:Dictionary=data['cur_workframe']
	self.cur_workframe=WorkFrame.from_raw(raw_workframe, existing)
	
	self.cur_inventory=cur_workframe.inventory
	
	var raw_tasks:Array=data.get('tasks',[])
	self.tasks=TaskState.from_array(raw_tasks, existing)
	
	var raw_workframes:Dictionary=data.get('workframes',{})
	self.workframes={}
	for key in raw_workframes:
		var rawframe=raw_workframes[key]
		var frame=WorkFrame.from_raw(rawframe, existing)
		self.workframes[key]=frame
	
	setup_display()
	update_inventory()
	return

func update_inventory():
	ex_inv_disp.display_data(
		self.cur_workframe.inventory,
		self.cur_workframe.targets,
		true
	)
	return

func setup_display():
	ex_task_display.hide()
	set_task_list()

func save_data(data_storage=null, existing:Dictionary={}):
	var data:Dictionary=data_storage if data_storage is Dictionary else self.main_data_struct
	data['editable']=self.cur_editable
	var raw_main=self.cur_workframe.to_raw(existing)
	data['cur_workframe']=raw_main
	var raw_tasks=TaskState.to_array(self.tasks, existing)
	data['tasks']=raw_tasks
	var raw_workframes={}
	for key in self.workframes:
		var frame:WorkFrame=self.workframes[key]
		var rawframe=frame.to_raw(existing)
		raw_workframes[key]=rawframe
	data['workframes']=raw_workframes
	return data

func set_workframe(workframe:WorkFrame):
	self.cur_workframe=workframe
	self.set_task_list()

func set_task_list():
	var texts:Array[String]=cur_workframe.get_cur_task_names().duplicate()
	texts.append("New task...")
	ex_cur_task_list.populate(texts)

func load_task(ind:int, is_cur:bool):
	var source:Array[TaskState]=[
		self.tasks,
		cur_workframe.current_tasks
	][int(is_cur)]
	var task:TaskState=null
	if len(source)==ind:
		var basetask:Task=Task.new("Untitled","Add description here",{},{})
		basetask.add_new(self.existing,'Task')
		task=TaskState.new(basetask,0,1,0)
		task.add_new(self.existing,'TaskState')
		source.append(task)
		self.setup_display()
	task=source[ind]
	var inv=cur_workframe.inventory
	ex_task_display.set_curstate(task,inv,is_cur)
	ex_task_display.show()

func insert_task(ind:int, task:Task):
	self.cur_workframe.insert_task(ind,task)
	set_task_list()

func remove_task(ind:int):
	self.cur_workframe.remove_task(ind)
	set_task_list()


func save_and_exit_function() -> void:
	save_and_exit.emit()
