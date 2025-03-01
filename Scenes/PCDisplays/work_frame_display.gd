extends MenuMode


signal save_and_exit


@export var editable:bool
@export var ex_task_display:Control
@export var ex_task_edit:Control
@export var ex_av_task_list:Control
@export var ex_cur_task_list:Control
@export var ex_subframe_list:Control
@export var ex_inv_disp:InventoryDisplay

var cur_editable:bool=false
var cur_workframe:WorkFrame
var cur_inventory:Dictionary
var tasks:Array[TaskState]
var workframes:Dictionary

var cur_task_ind:int=-1
var is_cur_in_workframe:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

func test():
	init_data()
	var raw_test_data=JSON.stringify(self.data,"  ")
	print(raw_test_data)
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
	print(cur_workframe.to_raw())
	save_data()

func on_open(data:Dictionary):
	load_data(data)
	show()
	return

func on_close(data:Dictionary):
	save_data(data)
	hide()
	return

func load_data(data:Dictionary):
	self.data=data
	if 'cur_workframe' not in data:
		init_data()
	
	self.cur_editable=data.get('editable',false)
	
	var raw_workframe:Dictionary=data['cur_workframe']
	self.cur_workframe=WorkFrame.from_raw(raw_workframe)
	
	self.cur_inventory=cur_workframe.inventory
	
	var raw_tasks:Array=data.get('tasks',[])
	self.tasks=TaskState.from_array(raw_tasks)
	
	var raw_workframes:Dictionary=data.get('workframes',{})
	self.workframes={}
	for key in raw_workframes:
		var rawframe=raw_workframes[key]
		var frame=WorkFrame.from_raw(rawframe)
		self.workframes[key]=frame
	update_display()
	ex_task_display.hide()
	ex_task_edit.hide()
	return

func update_display():
	ex_inv_disp.display_data(
		self.cur_workframe.inventory,
		self.cur_workframe.targets,
		true
	)
	var texts:Array[String]=cur_workframe.get_cur_task_names().duplicate()
	texts.append("New task...")
	ex_cur_task_list.populate(texts)
	var task_texts:Array[String]=[]
	for taskstate:TaskState in self.tasks:
		var got_name:String=taskstate.get_name()
		task_texts.append(got_name)
	task_texts.append("New task...")
	ex_av_task_list.populate(task_texts)
	var subfnl:Array[String]=[]
	ex_subframe_list.populate(subfnl)

func save_data(data_storage=null):
	var data:Dictionary=data_storage if data_storage is Dictionary else self.self.data
	data['editable']=self.cur_editable
	var raw_main=self.cur_workframe.to_raw()
	data['cur_workframe']=raw_main
	var raw_tasks=TaskState.to_array(self.tasks)
	data['tasks']=raw_tasks
	var raw_workframes={}
	for key in self.workframes:
		var frame:WorkFrame=self.workframes[key]
		var rawframe=frame.to_raw()
		raw_workframes[key]=rawframe
	data['workframes']=raw_workframes
	return data

func set_workframe(workframe:WorkFrame):
	self.cur_workframe=workframe
	update_display()

func load_task(ind:int, is_cur:bool):
	var source:Array[TaskState]=[
		self.tasks,
		cur_workframe.current_tasks
	][int(is_cur)]
	var task:TaskState=null
	if len(source)==ind:
		var basetask:Task=Task.new("Untitled","Add description here",{},{})
		task=TaskState.new(basetask,0,1,0)
		source.append(task)
		self.update_display()
		edit_task(is_cur, task)
	else:
		task=source[ind]
		exit_edit_task(is_cur, task)
	self.cur_task_ind=ind
	quicksave.emit()

func edit_task(is_cur: bool, task:TaskState):
	ex_task_display.hide()
	ex_task_edit.set_curstate(task, is_cur)
	ex_task_edit.show()
	quicksave.emit()

func exit_edit_task(is_cur: bool, task:TaskState):
	ex_task_edit.hide()
	ex_task_display.set_curstate(task, cur_workframe.inventory, is_cur)
	ex_task_display.show()
	quicksave.emit()

func insert_task(ind:int, task:Task):
	self.cur_workframe.insert_task(ind,task)
	update_display()
	quicksave.emit()

func remove_current_task(is_cur:bool):
	if is_cur:
		self.cur_workframe.remove_task(self.cur_task_ind)
	update_display()
	ex_task_edit.hide()
	ex_task_display.hide()
	quicksave.emit()

func remove_task(ind:int):
	self.cur_workframe.remove_task(ind)
	update_display()
	quicksave.emit()


func save_and_exit_function() -> void:
	save_and_exit.emit()
