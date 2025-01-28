extends Control
class_name MainScene

@onready var file_dialog: FileDialog = $FileDialog

@export var notesmenu:Control
@export var taskmenu:Control
@export var menus:Array[MenuMode] # UPGRADE TO 4.4
var menu_indices:Dictionary

var curmenu:MenuMode=null

var state:MainState=null
func _ready() -> void:
	# DisplayServer.window_set_min_size(Vector2i(800, 600))
	print(DisplayServer.window_get_min_size())
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
		self.curmenu.on_close(self.state.data)
	self.curmenu=next_menu
	if self.curmenu!=null:
		self.curmenu.on_open(self.state.data)

func init_data():
	self.state=MainState.init_test()
	setup_data("Created")

func dialog_load_data():
	var filepath=self.state.filepath
	var filename=self.state.filename
	file_dialog.file_mode=FileDialog.FILE_MODE_OPEN_FILE
	if filepath!="":
		var dirpath=filepath.get_base_dir()
		print(dirpath)
		file_dialog.current_dir=dirpath
	file_dialog.current_file=filename+".irlbp"
	file_dialog.show()

func exit():
	get_tree().quit()

func save_and_exit():
	decide_save()
	get_tree().quit()

func decide_save():
	self.state.name=namenode.text
	var filepath=self.state.filepath
	if not filepath:
		dialog_save_data()
	else:
		file_dialog.file_mode=FileDialog.FILE_MODE_SAVE_FILE
		finish_dialog(filepath)

func dialog_save_data():
	self.state.name=namenode.text
	var filepath=self.state.filepath
	file_dialog.file_mode=FileDialog.FILE_MODE_SAVE_FILE
	var filename=self.state.filename
	if filepath!=null:
		var dirpath=filepath.get_base_dir()
		file_dialog.current_dir=dirpath
	file_dialog.current_file=filename+".irlbp"
	file_dialog.show()


func finish_dialog(path: String) -> void:
	self.state.filepath=path
	if file_dialog.file_mode==FileDialog.FILE_MODE_SAVE_FILE:
		save_data(path)
	else:
		load_data(path)
	file_dialog.hide()

func save_data(path: String):
	if self.curmenu:
		self.curmenu.on_close(self.state.data)
	var result=self.state.save_data()
	if self.curmenu:
		self.curmenu.on_open(self.state.data)
	if result:
		setup_data('Saved')

func load_data(path:String):
	self.state=MainState.load_from_file(path)
	setup_data('Loaded')
	

func setup_data(last_change:String):
	namenode.text=self.state.name
	pathnode.text=self.state.filepath
	if self.curmenu:
		self.curmenu.on_open(self.state.data)
	toggle_functions(true)
	save_time_text.text=MainState.make_save_text(last_change)
