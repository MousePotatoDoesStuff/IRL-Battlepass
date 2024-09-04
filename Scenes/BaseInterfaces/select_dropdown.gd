extends Control
signal ButtonPressedSignal(ind:int)

var buttons=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var s="""Somebody once told me the world is gonna roll me
I ain't the smartest tool in the shed
	"""
	populate("Title",s.replace("\n","").split(" "))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func remove_button(button:Node):
	%Organizer.remove_child(button)
	button.queue_free()

func add_button(ind:int):
	var button=Button.new()
	button.text="Untitled"
	%Organizer.add_child(button)
	self.buttons.append(button)
	# Connect button's pressed signal to on_button_pressed

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

func populate(title:String, texts: Array[String]):
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

func on_button_pressed(button_index:int):
	ButtonPressedSignal.emit(button_index)
