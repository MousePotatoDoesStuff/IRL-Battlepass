extends Node
class_name Util

static func enumerate(L:Array):
	var reslist=[]
	var n=len(L)
	for i in range(n):
		var e=L[i]
		var newel=[i,e]
		reslist.append(newel)
	return reslist

static func dictitems(D:Dictionary):
	var reslist=[]
	for key in D:
		var val=D[key]
		var newel=[key,val]
		reslist.append(newel)
	return reslist

static func check_dict_int_ratio(checked:Dictionary,ref:Dictionary,limit:int=-1)->int:
	for E in ref:
		var refval:int=ref[E]
		if refval==0:
			continue
		var val:int=checked.get(E,0)
		var ratio:int=val/refval
		limit=limit if limit in range(ratio) else ratio
	return limit if limit!=INF else 0

static func add_dict_int_values(base:Dictionary,added:Dictionary,factor:int):
	for E in added:
		var addV=added[E]
		var V=base.get(E,0)
		V+=addV*factor
		base[E]=V
		if V==0:
			base.erase(E)

static func check_dict_values(dict:Dictionary,keys:Array):
	var res=[]
	for key in keys:
		if key not in dict:
			return null
		res.append(dict[key])
	return res
