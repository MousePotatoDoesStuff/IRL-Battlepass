extends MenuMode


var erasure_status:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func save_data(data_storage:Dictionary={})->Dictionary:
	if not erasure_status:
		return data_storage
	var technical=data_storage.get_or_add("__technical__",{})
	technical["ERASE_QUICKSAVE"]=true
	data_storage
	erasure_status=false
	return data_storage

func erase_data():
	self.erasure_status=true
	quicksave.emit()
