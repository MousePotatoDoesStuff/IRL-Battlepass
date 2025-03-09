extends MenuMode

@export var nametext:RichTextLabel
@export var notetext:TextEdit
var all_notes:Array[String]=["Main\nType your notes here."]
var current_note:int=0
func on_open(in_data:Dictionary):
	self.show()
	self.data=in_data
	var notes=self.data["notes"]
	if typeof(notes)==typeof("string"):
		self.all_notes=["Main"+"\n"+notes]
	elif typeof(notes)==typeof([]):
		self.all_notes=notes
	else:
		assert(false)
	self.showNote(0)

func showNote(current_note:int):
	var size=len(self.all_notes)
	if current_note<0:
		current_note+=size
	elif current_note>=size:
		current_note-=size
	current_note%=len(self.all_notes)
	self.current_note=current_note
	notetext.text=self.all_notes[self.current_note]
	showName()

func showName():
	nametext.text="[center]"+notetext.text.split("\n")[0]
	nametext.text+=" "+str(self.current_note+1)+"/"+str(len(self.all_notes))
	
	
func on_close(_in_data:Dictionary):
	on_edited()
	hide()
	return

func on_edited():
	showName()
	if self.all_notes[self.current_note]==notetext.text:
		return
	self.all_notes[self.current_note]=notetext.text
	quicksave.emit()

func save_data(data_storage:Dictionary={})->Dictionary:
	if data_storage.is_empty():
		data_storage=self.data
	self.all_notes[self.current_note]=notetext.text
	return data_storage if data_storage!=null else {}

func prev():
	self.showNote(self.current_note-1)

func next():
	self.showNote(self.current_note+1)

func new():
	self.all_notes.append("New note")
	self.showNote(self.current_note+1)

func remove():
	if len(self.all_notes)==1:
		return
	self.all_notes.remove_at(self.current_note)
	if self.current_note==len(self.all_notes):
		prev()
		return
	self.showNote(self.current_note)
