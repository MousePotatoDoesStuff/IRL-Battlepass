extends Control
class_name MainScene


@export var sidebar: Sidebar
@export var file_dialog: FileDialog
@export var notesmenu:Control
@export var taskmenu:Control
@export var menus:Array[MenuMode] # UPGRADE TO 4.4
var menu_indices:Dictionary

var curmenu:MenuMode=null

var state:MainState=MainState.new("","","",{})

func swap_menu(next_menu:MenuMode):
	if self.curmenu!=null:
		self.curmenu.on_close(self.state.data)
	self.curmenu=next_menu
	if self.curmenu!=null:
		self.curmenu.on_open(self.state.data)
	sidebar.toggle_visible()

# ---------------------------------------------------------------------------- #
#
# ---------------------------------------------------------------------------- #

func change_name(name:String):
	self.state.name=name

func init_data():
	self.state=MainState.init_test()
	setup_data("Created")

func dialog_load_data(new:bool=false):
	if new:
		init_data()
		return
	var filepath=self.state.filepath
	var filename=self.state.filename
	file_dialog.file_mode=FileDialog.FILE_MODE_OPEN_FILE
	if filepath!="":
		var dirpath=filepath.get_base_dir()
		print(dirpath)
		file_dialog.current_dir=dirpath
	file_dialog.current_file=filename+".irlbp"
	file_dialog.show()

func exit(save:bool):
	if save:
		decide_save()
	get_tree().quit()

func choice_save(choice:bool):
	if choice:
		decide_save()
	else:
		dialog_save_data()

func decide_save():
	var filepath=self.state.filepath
	if not filepath:
		dialog_save_data()
	else:
		file_dialog.file_mode=FileDialog.FILE_MODE_SAVE_FILE
		finish_dialog(filepath)

func dialog_save_data():
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
	self.setup_data("Loaded")

func setup_data(last_change:String):
	if self.curmenu:
		self.curmenu.on_open(self.state.data)
	self.sidebar.setup_data(self.state,last_change,self.menus)
