extends Window


signal DictChanged(isRew:bool)
var base:Dictionary={}
var isRew:bool
@export var DKI:DictKeyInput=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DKI == null:
		DKI=$DictKeyInput
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_value(base:Dictionary, key:String):
	self.base=base
	DKI.set_value(key,base.get(key,0))
	show()

func save_value():
	DKI.apply_value(self.base,true)
	hide()
	DictChanged.emit(isRew)
