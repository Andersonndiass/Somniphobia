# PauseMenu.gd
extends ColorRect

# Sinal para avisar o Player que queremos retomar o jogo.
signal resumed


func _on_resume_button_pressed():
	resumed.emit()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_resume_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(1.1, 1.1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
func _on_resume_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(1, 1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func _on_quit_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($QuitButton, "scale", Vector2(1.1, 1.1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_quit_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($QuitButton, "scale", Vector2(1, 1),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
