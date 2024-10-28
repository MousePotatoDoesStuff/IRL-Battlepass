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
	if ID not in existing_of_class:
		ID=str(ID)
	if ID not in existing_of_class:
		ID=str(ID)
	var cur_state=existing_of_class.get(ID,null)
	return cur_state

static func set_new(all_existing:Dictionary,classname:String,id:int,value:JSONReusable):
	"""
	Places newly initalised object in dictionary.
	"""
	if id==-1:
		value.add_new(all_existing,classname)
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
	var res:JSONReusable=process_from_raw(raw, existing)
	var ID=raw.get('id',-1)
	set_new(existing,classname,ID,res)
	raw['id']=res.id
	assert(false,"Copy this function into your class, omitting this line")
	return res

func postprocess(complex_values: Dictionary):
	assert(false,"Postprocessing function not implemented!")

func process_to_raw(existing:Dictionary):
	"""
	Creates object. Must be implemented in inheritor class.
	"""
	assert(false,"You forgot to implement process_to_raw!")

func to_raw(existing: Dictionary={})->Dictionary:
	if self.id==-1:
		return process_to_raw(existing)
	var raw={'id':self.id}
	var classname=get_class_name()
	if not check_for(raw,existing,classname):
		var rawtemp=process_to_raw(existing)
		var tempopen=existing.get_or_add(classname,{})
		tempopen[self.id]=rawtemp
	return {'id':self.id}

func add_new(all_existing:Dictionary,classname:String,raw_form:bool=false):
	var existing_of_class:Dictionary=all_existing.get(classname,{})
	all_existing[classname]=existing_of_class
	self.id=existing_of_class.get('next',0)
	var form=self
	if raw_form:
		form=self.to_raw(all_existing)
	existing_of_class[id]=form
	existing_of_class['next']=self.id+1
	return
