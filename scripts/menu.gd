extends Control

func _ready():
	$Titulo.modulate = Color(1, 1, 1, 0)
	$play.modulate = Color(1, 1, 1, 0)
	$config.modulate = Color(1, 1, 1, 0)
	$exit.modulate = Color(1, 1, 1, 0)
	$Titulo.position = Vector2(333, 26)
	$Titulo.rotation = 0
	$Titulo.scale = Vector2(0.9, 0.9)
	
	var entry_tween = create_tween()
	
	entry_tween.parallel().tween_property($play, "position:x", 522, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	entry_tween.parallel().tween_property($play, "modulate", Color(1, 1, 1, 1), 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	entry_tween.parallel().tween_property($config, "position:x", 494, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	entry_tween.parallel().tween_property($config, "modulate", Color(1, 1, 1, 1), 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	entry_tween.parallel().tween_property($exit, "position:x", 522, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	entry_tween.parallel().tween_property($exit, "modulate", Color(1, 1, 1, 1), 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	entry_tween.tween_property($Titulo, "modulate", Color(1, 1, 1, 1), 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	entry_tween.parallel().tween_property($Titulo, "position:y", 30, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	entry_tween.parallel().tween_property($Titulo, "scale", Vector2(1.1, 1.1), 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	entry_tween.tween_property($Titulo, "scale", Vector2(1.0, 1.0), 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	var tween = create_tween().set_loops()
	tween.tween_property($Titulo, "modulate", Color(1, 1, 1, 1), 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($Titulo, "position:y", 30, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	var float_tween = create_tween().set_loops()
	float_tween.tween_property($Titulo, "position:y", 22, 5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	float_tween.tween_property($Titulo, "position:y", 30, 5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var rotate_tween = create_tween().set_loops()
	rotate_tween.tween_property($Titulo, "rotation", PI/120, 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	rotate_tween.tween_property($Titulo, "rotation", -PI/120, 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	var scale_tween = create_tween().set_loops()
	scale_tween.tween_property($Titulo, "scale", Vector2(1.03, 1.03), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property($Titulo, "scale", Vector2(0.97, 0.97), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	
	
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _on_exit_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()
func _on_titulo_mouse_entered() -> void:
	$Titulo.position.x += 5
	var tween = create_tween()
	tween.tween_property($Titulo, "scale", Vector2(1.1, 1.1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_titulo_mouse_exited() -> void:
	$Titulo.position.x -= 5
	var tween = create_tween()
	tween.tween_property($Titulo, "scale", Vector2(1, 1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func tweenBtn(button_node: Control, scale_to: float) -> void:
	var tween = create_tween()
	tween.tween_property(button_node, "scale", Vector2(scale_to, scale_to),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
func _on_play_mouse_entered() -> void:
	tweenBtn($play, 1.2)
func _on_play_mouse_exited() -> void:
	tweenBtn($play, 1.0)
func _on_exit_mouse_entered() -> void:
	tweenBtn($exit, 1.2)
func _on_exit_mouse_exited() -> void:
	tweenBtn($exit, 1.0)
func _on_config_mouse_entered() -> void:
	tweenBtn($config, 1.2)
func _on_config_mouse_exited() -> void:
	tweenBtn($config, 1.0)
