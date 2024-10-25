extends Object
class_name JSONManager

static var classes={
	'Task':Task,
	'TaskState':TaskState,
	'WorkFrame':WorkFrame
}

static func load_existing(existing:Dictionary):
	var newexisting:Dictionary={}
	for clname in existing:
		var classused=classes[clname]
		var subexisting:Dictionary=existing[clname]
		var newsub:Dictionary={}
		newexisting[clname]=newsub
		for name in subexisting:
			if name is not int:
				newsub[name]=subexisting[name]
				continue
			var raw:Dictionary=subexisting[name]
			var obj=JSONReusable.from_raw(raw,newexisting)
			newsub[name]=obj
	return newexisting

static func save_existing(existing:Dictionary):
	var newexisting:Dictionary={}
	for clname in existing:
		var classused=classes[clname]
		var subexisting:Dictionary=existing[clname]
		var newsub:Dictionary={}
		newexisting[clname]=newsub
		for name in subexisting:
			if name is not int:
				newsub[name]=subexisting[name]
				continue
			var obj:JSONReusable=subexisting[name]
			var raw=obj.process_to_raw(newexisting)
			newsub[name]=raw
	return newexisting
