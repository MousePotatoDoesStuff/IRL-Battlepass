extends MenuMode


signal save(data:String)
signal exit
var data:Dictionary={}

func on_open(data:Dictionary):
	self.data=data.get('notes',"")
	$TextEdit.text=self.data

func on_close(data:Dictionary):
	self.data['notes']=$TextEdit.text
	save.emit($TextEdit.text)

func on_edited():
	self.data['notes']=$TextEdit.text
