extends Window


signal DictChanged(isRew:bool)
var base:Dictionary={}
var isRew:bool
@export var DKI:DictKeyInput=null

func _ready() -> void:
	if DKI == null:
		DKI=$DictKeyInput

func set_value(in_base:Dictionary, key:String):
	self.base=in_base
	DKI.set_value(key,self.base.get(key,0))
	show()

func save_value():
	DKI.apply_value(self.base,true)
	hide()
	DictChanged.emit(isRew)
