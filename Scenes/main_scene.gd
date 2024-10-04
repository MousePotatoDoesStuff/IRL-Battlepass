extends Control

@onready var file_dialog: FileDialog = $FileDialog

var data={'name':"Test Name"}
func _ready() -> void:
	pass

func open_notes():
	$Notes.load_notes(data.get('notes',""))
	$Notes.show()

func save_notes(notes:String):
	data['notes']=notes
	save_data()

func close_notes():
	$Notes.hide()

func load_data():
	var filepath=data.get('filepath')
	file_dialog.file_mode=FileDialog.FILE_MODE_OPEN_FILE
	var name=data.get('name','Untitled')
	if filepath!=null:
		var dirpath=filepath.get_base_dir()
		print(dirpath)
		file_dialog.current_dir=dirpath
	file_dialog.current_file=name+".irlbp"
	file_dialog.show()

func save_data():
	var filepath=data.get('filepath')
	file_dialog.file_mode=FileDialog.FILE_MODE_SAVE_FILE
	var name=data.get('name','Untitled')
	if filepath!=null:
		var dirpath=filepath.get_base_dir()
		print(dirpath)
		file_dialog.current_dir=dirpath
	file_dialog.current_file=name+".irlbp"
	file_dialog.show()


func finish_save_data(path: String) -> void:
	data['filepath']=path
	if file_dialog.file_mode==FileDialog.FILE_MODE_SAVE_FILE:
		var raw=JSON.stringify(data,"\t",true)
		var savefile=FileAccess.open(path,FileAccess.WRITE)
		savefile.store_line(raw)
		savefile.close()
	else:
		var savefile=FileAccess.open(path,FileAccess.READ)
		var raw=savefile.get_as_text()
		savefile.close()
		data=JSON.parse_string(raw)
	file_dialog.hide()
