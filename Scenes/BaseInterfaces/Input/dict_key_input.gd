extends Control
class_name DictKeyInput

signal DeleteSignal(key)
signal UpdateSignal
@export var allowDelete:bool=false
@export var var_name="Test"
@export var default_value="0"
@export var input_mode="natint"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$key.text=var_name
	$value.last_text=default_value
	$value.f_mode=input_mode
	$value._on_text_changed(default_value)
	self.toggleDelete(self.allowDelete)
	$ColorRect.color=Color.WEB_GRAY

func toggleDelete(in_allowDelete):
	self.allowDelete=in_allowDelete
	if self.allowDelete:
		$Button.show()
	else:
		$Button.hide()

func set_value(key:String, value):
	$key.text=key
	$value.text=str(value)

func show_change(_text:String):
	$ColorRect.color=Color.WEB_GREEN

func apply_value(target: Dictionary, convert_to_int: bool=false, show_apply=true):
	var key=$key.text
	var value=$value.text
	if convert_to_int:
		value=int(value)
	target[key]=value
	if show_apply:
		$ColorRect.color=Color.WEB_GRAY

func ondelete() -> void:
	DeleteSignal.emit($key.text)


func onedit() -> void:
	UpdateSignal.emit()
