extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_creditos_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($TextureRect/CanvasLayer2/Creditos, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func _on_creditos_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($TextureRect/CanvasLayer2/Creditos, "scale", Vector2(1, 1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_lore_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($TextureRect/CanvasLayer2/Lore, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_lore_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($TextureRect/CanvasLayer2/Lore, "scale", Vector2(1, 1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_cjr_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($TextureRect/CanvasLayer2/cjr, "scale", Vector2(1.2, 1.2),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_cjr_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($TextureRect/CanvasLayer2/cjr, "scale", Vector2(1, 1),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func _on_creditos_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/creditos.tscn")


func _on_lore_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/lore.tscn")


func _on_cjr_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/guia.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
