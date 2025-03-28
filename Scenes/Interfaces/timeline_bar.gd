extends Control

@export var size_in_units:float=0.0
@export var bg_color:Color=Color.RED
var images:Array[ColorRect]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.displayUnits([1,2,3],[Color.BLUE,Color.WEB_PURPLE,Color.LAVENDER])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getPositionFromClick()->float:
	var mouse_pos:Vector2=get_local_mouse_position()
	var relative_pos:float=mouse_pos.x/self.size.x
	if self.size_in_units>0.0:
		relative_pos/=self.size_in_units
		relative_pos=round(relative_pos)
		relative_pos*=self.size_in_units
	if relative_pos>1.0:
		relative_pos=1.0
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

func displayUnits(values:Array[int],colors:Array[Color]):
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
	var new_counts:Array=Util.accumulate(values,true)
	
	self.size_in_units=new_counts[-1]
	var ratio=self.size.x/self.size_in_units
	var new_locations:Array=Util.multiply(new_counts,ratio)
	for i in range(n):
		var object:ColorRect=self.images[i]
		object.position=Vector2(new_locations[i],0.0)
		object.size=Vector2(new_locations[i+1]-new_locations[i],self.size.y)
		object.color=colors[i]
		print(object.position,object.size)
	return
