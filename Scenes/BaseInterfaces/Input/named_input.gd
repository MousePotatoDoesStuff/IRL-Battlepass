extends Control


signal DeleteSignal
signal UpdateSignal
@export var allowDelete:bool=false
@export var var_name="Test"
@export var default_value="0"
@export var input_mode="natint"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$name.text=var_name
	$value.last_text=default_value
	$value.f_mode=input_mode
	$value._on_text_changed(default_value)
	if allowDelete:
		$Button.show()
	else:
		$Button.hide()

func set_value(value):
	$value._on_text_changed(str(value))

func get_value():
	return $value.get_value()


func ondelete() -> void:
	DeleteSignal.emit()

func onchange():
	UpdateSignal.emit()
