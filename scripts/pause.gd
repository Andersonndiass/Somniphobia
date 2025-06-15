extends CanvasLayer

func _ready() -> void:
	hide_pause_menu()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			hide_pause_menu()
		else:
			show_pause_menu()

func show_pause_menu() -> void:
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_pause_menu() -> void:
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_pressed() -> void:
	hide_pause_menu()
