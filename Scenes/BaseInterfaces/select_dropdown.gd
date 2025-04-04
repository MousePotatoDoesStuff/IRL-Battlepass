extends Control
class_name SelectDropdown
signal ButtonPressedSignal(ind:int)
@export var Organizer:BoxContainer

var buttons=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(Organizer is BoxContainer)
	var s="""Somebody once told me the world is gonna roll me 
I ain't the smartest tool in the shed
	"""
	var L=s.replace("\n","").split(" ")
	populate(L)

func remove_button(button:Node):
	Organizer.remove_child(button)
	button.queue_free()

func add_button(ind:int):
	var button:Button=Button.new()
	button.custom_minimum_size=Vector2(size.x,32)
	button.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS
	button.clip_text=true
	button.text="Untitled"
	Organizer.add_child(button)
	self.buttons.append(button)
	var temp=func():
		self.on_button_pressed(ind)
	button.pressed.connect(temp)

func remove_tail(count:int):
	for i in range(count):
		var button=self.buttons.pop_back()
		remove_button(button)
	return

func add_tail(count:int):
	var ind=buttons.size()
	for i in range(count):
		add_button(ind+i)
	return

func populate(texts: Array[String]):
	var n=len(texts)
	var n2=len(buttons)
	if n<n2:
		remove_tail(n2-n)
	elif n2<n:
		add_tail(n-n2)
	for i in range(n):
		var cur=self.buttons[i]
		cur.text=texts[i]
	return

func get_value(ind: int)->String:
	if ind not in range(len(self.buttons)):
		return ""
	return self.buttons[ind].text


func on_button_pressed(button_index:int):
	ButtonPressedSignal.emit(button_index)

func get_task():
	return
