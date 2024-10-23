extends Object
class_name JSONReusable

var id:int

static func get_class_name()->String:
	return ""

static func process_from_raw(raw: Dictionary, existing:Dictionary):
	"""
	Creates object. Must be implemented in inheritor class.
	"""
	assert(false,"You forgot to implement process_from_raw!")

static func check_for(raw:Dictionary, all_existing:Dictionary, classname:String):
	"""
	Checks if the object was already initialised.
	"""
	if classname not in all_existing:
		return null
	var existing_of_class:Dictionary=all_existing[classname]
	var ID=raw.get('id',-1)
	var cur_state=existing_of_class.get(ID,null)
	return cur_state

static func set_new(all_existing:Dictionary,classname:String,id:int,value:JSONReusable):
	"""
	Places newly initalised object in dictionary.
	"""
	if id==-1:
		return
	var existing_of_class:Dictionary=all_existing.get(classname,{})
	all_existing[classname]=existing_of_class
	existing_of_class[id]=value
	return

static func from_raw(raw: Dictionary, existing: Dictionary):
	"""
	Create function from processed JSON.
	"""
	var classname=get_class_name()
	var old:Task=check_for(raw, existing, classname)
	if old != null:
		return old
	var res=process_from_raw(raw, existing)
	var ID=raw.get('id',0)
	set_new(existing,classname,ID,res)
	assert(false,"Copy this function into your class, omitting this line")
	return res

func process_to_raw(existing:Dictionary):
	"""
	Creates object. Must be implemented in inheritor class.
	"""
	assert(false,"You forgot to implement process_to_raw!")

func to_raw(existing: Dictionary={})->Dictionary:
	var raw={'id':self.id}
	if check_for(raw,existing,get_class_name())!=null:
		return raw
	raw=process_to_raw(existing)
	return raw

func add_new(all_existing:Dictionary,classname:String):
	var existing_of_class:Dictionary=all_existing.get(classname,{})
	all_existing[classname]=existing_of_class
	var id=existing_of_class.get('next',0)
	existing_of_class[id]=self
	id+=1
	existing_of_class['next']=id
	return
