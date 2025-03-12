class_name VersionCheck extends Object

static func toList(version:String)->Array[int]:
	var step=version.split(".")
	var res:Array[int]=[]
	for el in step:
		res.append(int(el))
	return res

static func compare(v1:String,v2:String)->int:
	var reverse:int=1
	var lis1=toList(v1)
	var lis2=toList(v2)
	var d=len(lis1)-len(lis2)
	if d<0:
		var temp=lis2
		lis2=lis1
		lis1=temp
		reverse=-1
		d*=-1
	for i in range(d):
		lis2.append(0)
	for i in range(len(lis2)):
		if lis1[i]>lis2[i]:
			return -1*reverse
		if lis2[i]>lis1[i]:
			return reverse
	return 0

static func isUpToDate(version:String,minimums:Array[String]):
	for minimum in minimums:
		var cur = compare(version,minimum)
		if cur<=0:
			return minimum
	return ""
