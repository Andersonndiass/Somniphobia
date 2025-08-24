extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	GameManager.returned_to_menu.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/mundo2.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()
func _on_titulo_mouse_entered() -> void:
	$CanvasLayer2/Titulo.position.x += 5
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/Titulo, "scale", Vector2(1.1, 1.1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_titulo_mouse_exited() -> void:
	$CanvasLayer2/Titulo.position.x -= 5
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/Titulo, "scale", Vector2(1, 1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_play_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/play, "scale", Vector2(1.2, 1.2),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/play, "scale", Vector2(1, 1),0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_exit_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/exit, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_exit_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/exit, "scale", Vector2(1, 1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_config_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/config, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_config_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer2/config, "scale", Vector2(1, 1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func _on_config_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/config.tscn")
