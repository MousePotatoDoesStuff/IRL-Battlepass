class_name MainState extends Object

var name:String
var filename:String
var filepath:String
var data:Dictionary

func _init(
		in_name:String="Untitled",
		in_filename:String="Untitled",
		in_filepath:String="",
		in_data:Dictionary={}
	) -> void:
	self.name=in_name
	self.filename=in_filename
	self.filepath=in_filepath
	self.data=in_data
	return

static func load_from_data(data:Dictionary,version_minimums:Array[String]=[])->MainState:
	var version=data.get("version","0")
	var version_supported_by=VersionCheck.isUpToDate(version,version_minimums)
	if not version_supported_by:
		return null
	var name=data.get('name','Untitled')
	var filename=data.get('filename','Untitled')
	var filepath=data.get('filepath','')
	var new_obj=MainState.new(name,filename,filepath,data)
	return new_obj

static func init_test(version:String,version_minimums:Array[String]=[])->MainState:
	if not version_minimums:
		version_minimums=[]
	var raw_workframe={
	}
	var data={
		"filename": "test",
		# "filepath": "C:/Godot/Projects/IRL-Battlepass/test.irlbp",
		"name": "Test Name",
		"version": version,
		"editable": true,
		"cur_workframe": raw_workframe,
		"notes": ["Type your notes here."]
	}
	return load_from_data(data,version_minimums)

static func load_from_file(path:String,version_minimums:Array[String]=[])->MainState:
	var savefile=FileAccess.open(path,FileAccess.READ)
	if savefile==null:
		return null
	var raw=savefile.get_as_text()
	savefile.close()
	var temp_data=JSON.parse_string(raw)
	if temp_data is Array:
		temp_data=temp_data[0]
	if temp_data is Dictionary:
		return load_from_data(temp_data,version_minimums)
	assert(false,"Wrong savefile data type!")
	return MainState.new()

static func make_save_text(mode:String)->String:
	var time=Time.get_datetime_string_from_system()
	time=time.replace('T',' ')
	var data:Array[String]=[mode,time]
	return "[center]%s at %s" % data

func get_filepath():
	return

func to_data():
	self.data['name']=self.name
	self.data['filename']=self.filename
	self.data['filepath']=self.filepath
	return self.data

func save_data(path: String="", make_filepath:bool=true)->bool:
	if make_filepath:
		self.filepath=path
	if path=="":
		path=self.filepath
	if path=="":
		return false
	data=self.to_data()
	var raw=JSON.stringify(data,"\t",true)
	var savefile=FileAccess.open(path,FileAccess.WRITE)
	savefile.store_line(raw)
	savefile.close()
	return true

func open_menu(menu:MenuInstance):
	assert(false,"Function unimplemented!")
