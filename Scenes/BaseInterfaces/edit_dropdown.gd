extends Control
class_name EditDropdown
signal ButtonPressedSignal(ind:int)
@export var Organizer:BoxContainer
@export var is_cur:bool

var buttons:Array[DictKeyInput]=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_button(button:Node):
	Organizer.remove_child(button)
	button.queue_free()

func add_button(ind:int, is_cur:bool):
	var button:DictKeyInput=DictKeyInput.new()
	button.allowDelete=true
	button.var_name=str(ind)
	button.default_value='0'
	Organizer.add_child(button)
	self.buttons.append(button)

func remove_tail(count:int):
	for i in range(count):
		var button=self.buttons.pop_back()
		remove_button(button)
	return

func add_tail(count:int):
	var ind=buttons.size()
	for i in range(count):
		add_button(ind+i,is_cur)
	return

func populate(texts: Array[String]):
	var n=len(texts)
	var n2=len(buttons)
	if n<n2:
		remove_tail(n2-n)
	if n2<n:
		add_tail(n-n2)
	for i in range(n):
		var cur=self.buttons[i]
		cur.text=texts[i]
	return

func get_data():
	var new_data:Dictionary={}
	for entry in buttons:
		entry.apply_value(new_data,true)
	return new_data

func get_task():
	return
