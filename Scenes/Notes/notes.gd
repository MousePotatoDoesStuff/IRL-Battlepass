extends MenuMode



func on_open(in_data:Dictionary):
	self.data=in_data
	$TextEdit.text=self.data['notes']
	show()
	return

func on_close(_in_data:Dictionary):
	on_edited()
	hide()
	return

func on_edited():
	if self.data['notes']==$TextEdit.text:
		return
	self.data['notes']=$TextEdit.text
	quicksave.emit()

func save_data(data_storage=null)->Dictionary:
	var data:Dictionary=data_storage if data_storage is Dictionary else self.data
	self.data['notes']=$TextEdit.text
	return data_storage if data_storage!=null else {}
