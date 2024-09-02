extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_data({'a':1,'c':1},{'a':1,'c':2,'d':3,'e':4})
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_data(inventory:Dictionary, requirements:Dictionary):
	var sortdata=[]
	var sortdict={}
	
	for e in requirements:
		if requirements[e]==0:
			continue
		var inv=inventory.get(e,0)
		var req=requirements[e]
		var ratio:float=1.0*inv/req
		var L=sortdict.get(ratio,[])
		if ratio not in sortdict:
			sortdict[ratio]=L
			sortdata.append(ratio)
		L.append(e)
	sortdata.sort()
	
	var templ=[]
	for e in sortdata:
		templ.append_array(sortdict[e])
	
	var resl=[]
	for e in templ:
		var inv=inventory.get(e,0)
		var req=requirements.get(e,0)
		var color: Color = Color.BLUE if inv >= req else Color.RED
		var hex_color: String = color.to_html(false)
		var s: String = "[color=#%s]%s (%d/%d)[/color]" % [hex_color, e, inv, req]
		resl.append(s)
	$In.text="\n".join(resl)
