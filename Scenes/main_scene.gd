extends Control

@onready var file_dialog: FileDialog = $FileDialog
@export var namenode:TextEdit
@export var pathnode:RichTextLabel

var data={'name':"Test Name",'filename':"test.irlbp"}
func _ready() -> void:
	assert(namenode!=null)
	assert(pathnode!=null)
	namenode.text=data['name']
	pathnode.text="No path"
	pass

func open_notes():
	$Notes.load_notes(data.get('notes',""))
	$Notes.show()

func save_notes(notes:String):
	data['notes']=notes
	decide_save()

func close_notes():
	$Notes.hide()

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
