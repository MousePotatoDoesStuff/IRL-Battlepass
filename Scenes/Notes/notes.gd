extends MenuMode


signal save(data:String)
signal exit
var data:Dictionary={}

func on_open(data:Dictionary, existing:Dictionary):
	show()
	return

func on_close(data:Dictionary, existing:Dictionary):
	hide()
	return

func on_edited():
	self.data['notes']=$TextEdit.text
