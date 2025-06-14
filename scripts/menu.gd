extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()
func _on_titulo_mouse_entered() -> void:
	$Titulo.position.x += 5
	var tween = create_tween()
	tween.tween_property($Titulo, "scale", Vector2(1.1, 1.1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_titulo_mouse_exited() -> void:
	$Titulo.position.x -= 5
	var tween = create_tween()
	tween.tween_property($Titulo, "scale", Vector2(1, 1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_play_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($play, "scale", Vector2(1.2, 1.2),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_play_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($play, "scale", Vector2(1, 1),0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_exit_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($exit, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_exit_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($exit, "scale", Vector2(1, 1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_config_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($config, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_config_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($config, "scale", Vector2(1, 1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
