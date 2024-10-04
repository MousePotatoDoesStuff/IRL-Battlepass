extends Control


signal save(data:String)
signal exit


func load_notes(data:String):
	$TextEdit.text=data

func save_and_exit():
	save.emit($TextEdit.text)
	exit.emit()

func only_exit():
	exit.emit()

func only_save():
	save.emit($TextEdit.text)

func nothing_lmao():
	return
