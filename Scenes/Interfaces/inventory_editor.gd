extends Control
class_name InventoryEditor
signal DataChangedSignal
@export var Organizer:BoxContainer
@export var Template:DictKeyInput
var dict:Dictionary
var entries:Array[DictKeyInput]=[]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(Organizer is BoxContainer)
	assert(Template is DictKeyInput)
	return

func remove_entry(entry:Node):
	Organizer.remove_child(entry)
	entry.queue_free()

func add_entry(ind:int):
	var entry:DictKeyInput=Template.duplicate()
	entry.toggleDelete(true)
	Organizer.add_child(entry)
	self.entries.append(entry)
	var temp=func(key):
		delete_entry(key,ind)
	entry.DeleteSignal.connect(temp) # Add ind to variables, connect to delete_entry
	

func remove_tail(count:int):
	for i in range(count):
		remove_entry(self.entries.pop_back())
	return


func add_tail(count:int):
	var ind=entries.size()
	for i in range(count):
		add_entry(ind+i)
	return

func populate(dict:Dictionary):
	self.dict=dict
	var n=len(dict)
	var n2=len(entries)
	if n<n2:
		remove_tail(n2-n)
	elif n2<n:
		add_tail(n-n2)
	var i=0
	for e in dict:
		var cur=self.entries[i]
		cur.set_value(e,dict[e])
		i+=1
	return

func retrieve_data(dict:Dictionary=self.dict):
	dict.clear()
	for el in self.entries:
		el.apply_value(dict,true)

func refresh():
	retrieve_data()
	populate(self.dict)

func delete_entry(key,ind):
	var to_delete:DictKeyInput=entries.pop_at(ind)
	self.dict.erase(key)
	to_delete.queue_free()
	return

func new_entry():
	var X={}
	$ScrollContainer/ArchOrganizer/AddInput.apply_value(X,true)
	for e in X:
		if e in self.dict:
			self.dict[e]=X[e]
			self.populate(dict)
		else:
			var n=len(self.dict)
			self.dict[e]=X[e]
			self.add_entry(n)
			self.entries[-1].set_value(e,X[e])
	# TODO optimise
