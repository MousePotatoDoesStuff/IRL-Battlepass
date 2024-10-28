extends MenuMode


signal save(data:String)
signal exit
var data:Dictionary={}

func on_open(data:Dictionary):
	self.data=data
	$TextEdit.text=self.data['notes']
	show()
	return

func on_close(data:Dictionary):
	on_edited()
	hide()
	return

func on_edited():
	self.data['notes']=$TextEdit.text
