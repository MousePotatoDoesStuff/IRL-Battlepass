extends MenuMode

var base_dir:Array=[]
signal chosen_save(path:String)
func on_open(_data:Dictionary):
	self.data=_data
	var savedict=_data["temp"]
	var filepath:String=savedict["filepath"]
	var dirpath=filepath.get_base_dir()
	var temp = DirAccess.get_files_at(dirpath)

	base_dir.append(savedict["filename"]+".godot")
	$SelectDropdown.populate(base_dir)
	show()
	return

func on_close(_data:Dictionary):
	hide()
	return

func save_data(data_storage:Dictionary={})->Dictionary:
	return data_storage


func save_to(ind: int) -> void:
	var path = self.base_dir[ind]
	chosen_save.emit(path)
