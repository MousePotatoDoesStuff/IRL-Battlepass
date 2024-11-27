extends MenuMode


var data:Dictionary={}

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
	self.data['notes']=$TextEdit.text
