class_name MenuManager extends Control


@export var menus:Array[MenuInstance]=[]
var stack:Array[int]=[]
@export var current_menu=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(not menus.is_empty())
	for menu in menus:
		menu.close()
	menus[current_menu].open({})
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_menu(next_menu:int, preloaded_data:Dictionary={}, stacking_last:bool=true):
	if next_menu==MenuInstance.SPECIAL.NO_SWAP:
		return
	if next_menu==MenuInstance.SPECIAL.CLOSE:
		return self.close_menu(preloaded_data)
	var raw_data:Dictionary=self.menus[self.current_menu].close()
	raw_data.merge(preloaded_data,true)
	var processed_data=process_open_menu(raw_data)
	if stacking_last:
		self.stack.append(current_menu)
	self.current_menu=next_menu
	self.menus[self.current_menu].open(raw_data)
	return

func close_menu(preloaded_data:Dictionary={}):
	var nex_menu=self.stack.pop_back()
	self.open_menu(nex_menu,preloaded_data,false)

func process_open_menu(input_data:Dictionary)->Dictionary:
	return input_data
