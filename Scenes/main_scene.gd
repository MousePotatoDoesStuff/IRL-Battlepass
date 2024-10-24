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
func _ready() -> void:
	assert(namenode!=null)
	assert(pathnode!=null)
	assert(functionslist is VBoxContainer)
	namenode.text=data['name']
	pathnode.text="No path"
	toggle_functions(false)

func toggle_functions(enabled:bool=true):
	for obj:Button in self.functionslist.get_children():
		obj.disabled=not enabled
	var text='Save or load to enable functions'
	if enabled:
		text='Functions enabled'
	function_state_text.text="[center]"+text
	return

func swap_menu(next_menu:MenuMode):
	if self.curmenu!=null:
		self.curmenu.on_close(self.data)
	self.curmenu=next_menu
	self.curmenu.on_open(self.data)

func open_notes():
	notesmenu.load_notes(data.get('notes',""))
	notesmenu.show()

func open_tasks() -> void:
	taskmenu.load_data(data)
	taskmenu.show()

func close_notes():
	notesmenu.hide()

func close_tasks():
	taskmenu.save_data(data)
	taskmenu.hide()
	decide_save()

func save_notes(notes:String):
	data['notes']=notes
	decide_save()

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
	if filepath==null:
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
	toggle_functions(true)

func save_data(path: String):
	data['name']=namenode.text
	var raw=JSON.stringify(data,"\t",true)
	var savefile=FileAccess.open(path,FileAccess.WRITE)
	savefile.store_line(raw)
	savefile.close()

func load_data(path:String):
	var savefile=FileAccess.open(path,FileAccess.READ)
	var raw=savefile.get_as_text()
	savefile.close()
	data=JSON.parse_string(raw)
	namenode.text=data.get('name','Untitled')
	pathnode.text=path
