extends Control
class_name MainScene

var INTERNAL_SAVE=ProjectSettings.globalize_path("user://autosave.irlbp")
enum PlatformTarget{
	ANDROID,
	DETECT,
	LINUX,
	WEB,
	WINDOWS
}
@export var autosaving_target_parent:Control
@export var platform_target:PlatformTarget=PlatformTarget.DETECT
@export var sidebar: Sidebar
@export var file_dialog: FileDialog
@export var notesmenu:Control
@export var taskmenu:Control
@export var menus:Array[MenuMode] # UPGRADE TO 4.4
var menu_indices:Dictionary

var curmenu:MenuMode=null

var state:MainState=null
var force_exit:bool=false
var is_save:bool=false
var autosaving_targets:Array[MenuMode]=[]

func _ready() -> void:
	assert(self.autosaving_target_parent!=null)
	self.load_data(INTERNAL_SAVE)
	if self.state==null:
		self.init_data()
		if self.state.save_data(INTERNAL_SAVE,false):
			print("Internal save created.")
	else:
		print("Internal save loaded.")
	for menu in self.autosaving_target_parent.get_children():
		if menu is MenuMode:
			menu.quicksave.connect(self.on_quicksave)

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
	if OS.has_feature("android"):
		self.state.filepath="user://"
	setup_data("Created")

func choose_load_method(new:bool=false):
	if self.platform_target==PlatformTarget.ANDROID:
		return

func dialog_load_data(new:bool=false):
	force_exit=false
	self.is_save=false
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
		force_exit=true
		if not decide_save():
			return
	get_tree().quit()

func choice_save(choice:bool):
	self.is_save=true
	force_exit=false
	if choice:
		decide_save()
	else:
		dialog_save_data()

func decide_save()->bool:
	self.is_save=true
	var filepath=self.state.filepath
	if not filepath:
		dialog_save_data()
		return false
	finish_dialog(filepath)
	return true

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
	if self.is_save:
		save_data(path)
	else:
		load_data(path)
	file_dialog.hide()

func save_data(path: String):
	if self.curmenu:
		self.curmenu.save_data(self.state.data)
	var data=self.state.data
	if data.get("__technical__",{}).get("ERASE_QUICKSAVE",false):
		DirAccess.remove_absolute(path)
		self.exit(false)
		return
	var result=self.state.save_data(path)
	if result:
		self.sidebar.setup_data(self.state,"Saved",self.menus)
		return true
	if force_exit:
		self.exit(false)
	return false

func load_data(path:String):
	force_exit=false
	self.is_save=false
	var state=MainState.load_from_file(path)
	if state==null:
		return
	self.state=state
	self.setup_data("Loaded")

func setup_data(last_change:String):
	if self.curmenu:
		self.curmenu.on_open(self.state.data)
	self.sidebar.setup_data(self.state,last_change,self.menus)

func on_quicksave():
	self.save_data(self.INTERNAL_SAVE)
