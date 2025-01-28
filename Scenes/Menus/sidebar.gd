extends Control

signal menu_opened(menu_name:String)
@export var func_parent:Control
var menus:Array[MenuMode]
var buttons:Array[Button]=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(func_parent,"LoadedFunctions parent node not specified!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_load(in_menus:Array[MenuMode]):
	for button in buttons:
		button.queue_free()
	self.menus=in_menus
	for menu in self.menus:
		var button=Button.new()
		self.buttons.append(button)
		self.func_parent.add_child(button)
		button.text=menu.menu_name
		button.pressed.connect(menu.on_open)
