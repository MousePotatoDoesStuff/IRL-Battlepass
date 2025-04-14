extends MenuMode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_open(_data:Dictionary):
	show()
	return

func on_close(_data:Dictionary):
	hide()
	return

func save_data(data_storage:Dictionary={})->Dictionary:
	return data_storage
