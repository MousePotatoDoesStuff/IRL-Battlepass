extends Control


var rows:Array[TaskRow]
var bars:Array[TimelineBar]
var colors:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bars=[$template]
	var test:TaskRow=TaskRow.zeroInit(10,0)
	print(test.tasks)
	print(test.setRange(-2,-1,1))
	print(test.setRange(3,5,2))
	print(test.setRange(9,11,2001))
	print(test.setRange(69,420,1337))
	print(test.setRange(3,2,-1))
	print(test.tasks)
	print(test.getRanges())
	print(test.getRangeValues())
	var colors:Dictionary={
		0:Color.BLACK,
		1:Color.RED
	}
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func removeExcess(new_count:int):
	for i in range(new_count,len(self.bars)):
		var temp:TimelineBar=self.bars.pop_back()
		temp.queue_free()

func addExcess(new_count:int):
	for i in range(len(self.images),new_count):
		var temp:TimelineBar=$template.duplicate()
		self.add_child(temp)
		self.images.append(temp)

func displayUnits(values:Array[TaskRow],colors:Dictionary,stack:bool,default_color:Color=Color.WHITE):
	var n=len(values)
	assert(n==len(colors))
	assert(n!=0)
	self.values=values.duplicate()
	if n<len(self.images):
		self.removeExcess(n)
	elif n>len(self.images):
		self.addExcess(n)
	self.colors=colors
	for i in range(len(values)):
		var bar:TimelineBar=self.bars[i]
		var row:TaskRow=values[i]
		var ranges:Array[int]=row.getRanges()
		var ran_values:Array[int]=row.getRangeValues()
		var value_colors:Array[Color]=[]
		for value in ran_values:
			var ran_color=colors.get(value,default_color)
			value_colors.append(value)
		bar.displayUnits(ranges,value_colors,false)
		
