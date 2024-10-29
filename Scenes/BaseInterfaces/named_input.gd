extends Control


signal DeleteSignal
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
	if allowDelete:
		$Button.show()
	else:
		$Button.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_value(target: Dictionary):
	return $value.last_text


func ondelete() -> void:
	DeleteSignal.emit()
