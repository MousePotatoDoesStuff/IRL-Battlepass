extends Object
class_name JSONReusable

var id:int

static func process_from_raw(raw: Dictionary, existing:Dictionary):
	return null

static func check_for(raw:Dictionary, all_existing:Dictionary, classname:String):
	if classname not in all_existing:
		return null
	var existing_of_class:Dictionary=all_existing[classname]
	var ID=raw.get('id',-1)
	var cur_state=existing_of_class.get(ID,null)
	return cur_state

static func set_new(all_existing:Dictionary,classname:String,id:int,value):
	if id==-1:
		return
	var existing_of_class:Dictionary=all_existing.get(classname,{})
	all_existing[classname]=existing_of_class
	existing_of_class[id]=value
	return

static func from_raw_base(raw: Dictionary, existing: Dictionary, classname:String=''):
	var old:Task=check_for(raw, existing, classname)
	if old != null:
		return old
	var res=process_from_raw(raw, existing)
	var ID=raw.get('id',0)
	set_new(existing,classname,ID,res)

func add_new(all_existing:Dictionary,classname:String):
	var existing_of_class:Dictionary=all_existing.get(classname,{})
	all_existing[classname]=existing_of_class
	var id=existing_of_class.get('next',0)
	existing_of_class[id]=self
	id+=1
	existing_of_class['next']=id
	return
