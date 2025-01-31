class_name Sidebar extends Control


signal open_menu_signal(menu:MenuMode)
signal change_name_signal(name:String)
signal load_signal(new:bool)
signal save_signal(choice:bool)
signal exit_signal(save:bool)
@export_category("Text nodes")
@export var namenode:TextEdit
@export var pathnode:RichTextLabel
@export var save_time_text:RichTextLabel
@export_category("Functions")
@export var functionslist:VBoxContainer
@export var func_parent:Control
var menus:Array[MenuMode]
var buttons:Array[Button]=[]
var state:MainState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	assert(func_parent,"LoadedFunctions parent node not specified!")
	setup_data(self.state,"Created",[])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_data(new_state:MainState,last_change:String,in_menus:Array[MenuMode]):
	self.state=new_state
	if self.state != null:
		namenode.text=self.state.name
		pathnode.text=self.state.filepath
	if self.state == null:
		functionslist.hide()
	else:
		functionslist.show()
	update_menus(in_menus)
	save_time_text.text=MainState.make_save_text(last_change)

func update_menus(in_menus:Array[MenuMode]):
	for button in buttons:
		button.queue_free()
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
	save_signal.emit(false, self.name)


func _on_save_as_pressed() -> void:
	save_signal.emit(true, self.name)


func _on_save_and_exit_pressed() -> void:
	exit_signal.emit(true)


func toggle_visible() -> void:
	var vis = $Control.visible
	if vis:
		$Control.hide()
	else:
		$Control.show()
