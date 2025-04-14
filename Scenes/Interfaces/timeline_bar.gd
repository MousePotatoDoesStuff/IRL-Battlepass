extends Control
class_name TimelineBar

signal clicked(x_pos:int)

@export var size_in_units:float=0.0
@export var bg_color:Color=Color.RED
@onready var images:Array[ColorRect]=[$template]
var new_counts:Array=[]
var colors:Array[Color]=[]
var last_loc=0
var down=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bg.hide()
	$template.show()
	self.displayUnits([1,2,3],[Color.BLUE,Color.WEB_PURPLE,Color.LAVENDER],false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.sendClickInput()
	else:
		down=false
	pass

func getPositionFromClick()->float:
	var mouse_pos:Vector2=get_local_mouse_position()
	var relative_pos:float=mouse_pos.x/self.size.x
	if not down:
		if mouse_pos.y<0 or mouse_pos.y>self.size.y:
			return self.last_loc
		if relative_pos<0:
			return self.last_loc
		if relative_pos>1:
			return self.last_loc
		self.down=true
	if self.size_in_units>0:
		relative_pos*=self.size_in_units
		relative_pos=ceil(relative_pos)
		relative_pos/=self.size_in_units
	return relative_pos
	

func removeExcess(new_count:int):
	for i in range(new_count,len(self.images)):
		var temp:ColorRect=self.images.pop_back()
		temp.queue_free()

func addExcess(new_count:int):
	for i in range(len(self.images),new_count):
		var temp:ColorRect=$template.duplicate()
		self.add_child(temp)
		self.images.append(temp)

func displayUnits(values:Array[int],colors:Array[Color],stack:bool):
	var n=len(values)
	assert(n==len(colors))
	if n==0:
		n=1
		values=[1.0]
		colors=[self.bg_color]
	if n<len(self.images):
		self.removeExcess(n)
	elif n>len(self.images):
		self.addExcess(n)
	if stack:
		self.new_counts=Util.accumulate(values,true)
	else:
		self.new_counts=[0]+values
	self.colors=colors
	self.size_in_units=self.new_counts[-1]
	self.finalDisplayUnits()

func finalDisplayUnits():
	print(new_counts)
	var ratio=self.size.x/self.size_in_units
	print(self.size)
	var new_locations:Array=Util.multiply(new_counts,ratio)
	var n=len(self.colors)
	var last:float=new_locations[0]
	for i in range(n):
		var object:ColorRect=self.images[i]
		var cur:float=new_locations[i+1]
		if cur<last:
			cur=last
		object.position=Vector2(last,0.0)
		object.size=Vector2(cur-last,self.size.y)
		object.color=self.colors[i]
		last=cur
	return


func _on_resized() -> void:
	if len(self.colors)==0:
		return
	self.finalDisplayUnits()


func sendClickInput() -> void:
	var input:float=self.getPositionFromClick()
	if input==self.last_loc:
		return
	self.last_loc=input
	var loc:int=int(input*self.size_in_units)
	clicked.emit(loc)
