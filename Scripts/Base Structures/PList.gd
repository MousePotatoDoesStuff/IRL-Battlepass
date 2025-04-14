class_name PList extends Object

static func GetUniqueElements(arr,null_element=null):
	var res=[]
	for e in arr:
		if e==null_element:
			continue
		null_element=e
		res.append(e)
	return res

static func GetUniqueElementsInt(arr:Array[int],null_element=null)->Array[int]:
	var res:Array[int]=[]
	for e in arr:
		if e==null_element:
			continue
		null_element=e
		res.append(e)
	return res

static func GetElementCounts(arr:Array)->Array[int]:
	if arr.is_empty():
		return [0]
	var res:Array[int]=[0]
	var cur=arr[0]
	for i in range(len(arr)):
		var e=arr[i]
		if e!=cur:
			cur=e
			res.append(0)
		res[-1]+=1
	return res
