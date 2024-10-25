extends Control
class_name MainScene

@onready var file_dialog: FileDialog = $FileDialog
@export var namenode:TextEdit
@export var pathnode:RichTextLabel

@export var notesmenu:Control
@export var taskmenu:Control
@export var functionslist:VBoxContainer
@export var function_state_text:RichTextLabel

var curmenu:MenuMode=null

var data={'name':"Test Name",'filename':"test"}
var existing={}
func _ready() -> void:
	assert(namenode!=null)
	assert(pathnode!=null)
	assert(functionslist is VBoxContainer)
	namenode.text=data['name']
	pathnode.text="No path"
	toggle_functions(false)

func toggle_functions(enabled:bool=true):
	var buttons:Array[Button]=[]
	for obj in self.functionslist.get_children():
		if obj is Button:
			buttons.append(obj)
	for obj in buttons:
		obj.disabled=not enabled
	var text='Create new or load to enable functions'
	if enabled:
		text='Functions enabled'
	function_state_text.text="[center]"+text
	return

func swap_menu(next_menu:MenuMode):
	if self.curmenu!=null:
		self.curmenu.on_close(self.data,self.existing)
	self.curmenu=next_menu
	if self.curmenu!=null:
		self.curmenu.on_open(self.data,self.existing)

func init_data():
	var raw_workframe={
		
	}
	self.existing={}
	self.data={
		"filename": "test",
		"filepath": "C:/Godot/Projects/IRL-Battlepass/test.irlbp",
		"name": "Test Name",
		
		"editable": true,
		"cur_workframe": raw_workframe,
		"notes": "Type your notes here."
	}
	toggle_functions(true)

func dialog_load_data():
	var filepath=data.get('filepath')
	file_dialog.file_mode=FileDialog.FILE_MODE_OPEN_FILE
	var name=data.get('filename','Untitled')
	if filepath!=null:
		var dirpath=filepath.get_base_dir()
		print(dirpath)
		file_dialog.current_dir=dirpath
	file_dialog.current_file=name+".irlbp"
	file_dialog.show()

func decide_save():
	data['name']=namenode.text
	var filepath=data.get('filepath')
	if not filepath:
		dialog_save_data()
	else:
		file_dialog.file_mode=FileDialog.FILE_MODE_SAVE_FILE
		finish_dialog(filepath)

func dialog_save_data():
	data['name']=namenode.text
	var filepath=data.get('filepath')
	file_dialog.file_mode=FileDialog.FILE_MODE_SAVE_FILE
	var name=data.get('filename','Untitled')
	if filepath!=null:
		var dirpath=filepath.get_base_dir()
		file_dialog.current_dir=dirpath
	file_dialog.current_file=name+".irlbp"
	file_dialog.show()


func finish_dialog(path: String) -> void:
	data['filepath']=path
	if file_dialog.file_mode==FileDialog.FILE_MODE_SAVE_FILE:
		save_data(path)
	else:
		load_data(path)
	file_dialog.hide()

func save_data(path: String):
	data['name']=namenode.text
	var existing_raw=JSONManager.save_existing(self.existing)
	var pre_raw=[self.data,existing_raw]
	var raw=JSON.stringify(pre_raw,"\t",true)
	var savefile=FileAccess.open(path,FileAccess.WRITE)
	savefile.store_line(raw)
	savefile.close()

func load_data(path:String):
	var savefile=FileAccess.open(path,FileAccess.READ)
	var raw=savefile.get_as_text()
	savefile.close()
	var temp_data=JSON.parse_string(raw)
	if temp_data is Array:
		self.data=temp_data[0]
		self.existing=JSONManager.load_existing(temp_data[1])
	elif temp_data is Dictionary:
		self.data=temp_data
		self.existing={}
	else:
		assert(false,"Wrong savefile data type!")
	namenode.text=data.get('name','Untitled')
	pathnode.text=path
	if self.curmenu:
		self.curmenu.on_open(self.data,self.existing)
	toggle_functions(true)
