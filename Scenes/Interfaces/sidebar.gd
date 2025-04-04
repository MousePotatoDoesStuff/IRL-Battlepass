class_name Sidebar extends Control


signal open_menu_signal(menu:MenuMode)
signal change_name_signal(name:String)
signal load_signal(new:bool)
signal save_signal(choice:bool)
signal exit_signal(save:bool)

@export_category("Text nodes")
@export var namenode:TextEdit
@export var save_time_text:RichTextLabel
@export var version_and_release:RichTextLabel
@export_category("Functions")
@export var functionslist:VBoxContainer
@export var func_parent:Control

var menus:Array[MenuMode]
var buttons:Array[Button]=[]
var state:MainState
var is_saveload:bool=true

func _ready() -> void:
	return
	
	assert(func_parent,"LoadedFunctions parent node not specified!")
	setup_data(self.state,"Created",[])

func remove_save_and_load():
	is_saveload=false
	functionslist.hide()
	$Control/MainMenuDropdown/VBoxContainer/LSF/Load.hide()

func on_init(init_data:Dictionary) -> void:
	var version:String=init_data["version"]
	var release_date:String=init_data["release_date"]
	assert(version_and_release)
	version_and_release.text="Version: %s\nRelease date: %s" % [version,release_date]

func setup_data(new_state:MainState,last_change:String,in_menus:Array[MenuMode]):
	self.state=new_state
	if self.state != null:
		namenode.text=self.state.name
	if self.state == null or not is_saveload:
		functionslist.hide()
	else:
		functionslist.show()
	update_menus(in_menus)
	save_time_text.text=MainState.make_save_text(last_change)

func update_menus(in_menus:Array[MenuMode]):
	for button in buttons:
		button.queue_free()
	buttons=[]
	self.menus=in_menus
	for menu in self.menus:
		var button=Button.new()
		self.buttons.append(button)
		self.func_parent.add_child(button)
		button.text=menu.menu_name
		var open_menu = func(): open_menu_signal.emit(menu)
		button.pressed.connect(open_menu)


func _on_new_pressed() -> void:
	load_signal.emit(true)


func _on_load_pressed() -> void:
	load_signal.emit(false)


func _on_exit_pressed() -> void:
	exit_signal.emit(false)


func _on_save_pressed() -> void:
	save_signal.emit(true)


func _on_save_as_pressed() -> void:
	save_signal.emit(false)


func _on_save_and_exit_pressed() -> void:
	exit_signal.emit(true)


func toggle_visible() -> void:
	var vis = $Control.visible
	if vis:
		$Control.hide()
	else:
		$Control.show()
