extends Button

@export var manager:MainScene
@export var menu:MenuMode
signal OnClickSignal(menu:MenuMode)

func _ready() -> void:
	assert(manager is MainScene)
	assert(menu is MenuMode)
	self.pressed.connect(on_click)
	self.OnClickSignal.connect(manager.swap_menu)

func on_click():
	OnClickSignal.emit(menu)
