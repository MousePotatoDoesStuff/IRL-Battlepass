extends Object

class_name TaskRow

var tasks:Array[int]=[0,1]
func _init(_tasks:Array[int]) -> void:
	self.tasks=_tasks

static func zeroInit(size:int,zero:int=0)->TaskRow:
	var raw:Array[int]=[]
	raw.resize(size)
	raw.fill(zero)
	var res:TaskRow=TaskRow.new(raw)
	return res

func save()->Array[int]:
	return self.tasks.duplicate()

func setRange(start:int,end:int,task:int)->int:
	start=max(start,0)
	end=min(end,len(tasks))
	if start>=end:
		return 0
	for cur in range(start,end):
		print(cur)
		self.tasks[cur]=task
	return end-start

func getRanges()->Array[int]:
	var res:Array[int]=PList.GetElementCounts(self.tasks)
	return res
	

func getRangeValues()->Array[int]:
	var res=PList.GetUniqueElementsInt(self.tasks)
	return res
