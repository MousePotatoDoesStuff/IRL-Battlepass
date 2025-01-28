extends LineEdit

signal EditedSignal
@export var default_text="1"
var last_text=""
@export var f_mode="natint"
var funcs={
	"int":is_int,
	"natint":is_natint,
	"default":ci_any
}

func _ready() -> void:
	_on_text_changed(default_text)

func _on_text_changed(new_text: String) -> void:
	var tester:Callable=self.funcs["default"]
	tester=funcs.get(f_mode,tester)
	var carcol=caret_column
	var res:String=tester.call(new_text,last_text)
	text=res
	caret_column=carcol
	if last_text==text:
		return
	last_text=text
	EditedSignal.emit()

func get_value():
	if self.f_mode in ["int","natint"]:
		return int(self.text)
	return self.text

static func ci_any(s:String,_s2:String)->String:
	return s

static func is_int(s:String,s2:String)->String:
	if s.is_valid_int():
		return str(int(s))
	if s == "-":
		return "0"
	if s == "+":
		return "0"
	return s2

static func is_natint(s:String,s2:String)->String:
	for e in s:
		if e not in '1234567890':
			return s2
	if s == "":
		s="0"
	return str(int(s))

static func is_float(s:String,s2:String)->String:
	return s if s.is_valid_float() else s2
