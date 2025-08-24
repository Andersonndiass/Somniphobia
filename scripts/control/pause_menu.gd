# PauseMenu.gd (versão corrigida)
extends ColorRect

# Não precisamos mais do sinal 'resumed', a comunicação é direta com o GameManager

func _ready() -> void:
	# Conecta aos sinais do GameManager para se esconder/mostrar
	GameManager.game_paused.connect(show)
	GameManager.game_resumed.connect(hide)
	
	# Esconde o menu no início do jogo
	hide()
	
	# Estiliza os botões
	$QuitButton.add_theme_color_override("font_color", Color("white"))
	$ResumeButton.add_theme_color_override("font_color", Color("white"))
	$QuitButton.add_theme_color_override("font_hover_color", Color("#660303"))
	$ResumeButton.add_theme_color_override("font_hover_color", Color("#660303"))

# --- CORRIGIDO ---
# A lógica de resumir o jogo foi movida para cá, onde pertence.
func _on_resume_button_pressed():
	# Avisa ao GameManager para resumir o jogo
	GameManager.resume_game()
	# Captura o mouse para voltar ao controle do jogador
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_button_pressed():
	get_tree().quit()

# --- CORRIGIDO ---
# Esta função agora só cuida do efeito visual de hover.
func _on_resume_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(1.3, 1.3), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_resume_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($ResumeButton, "scale", Vector2(1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_quit_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($QuitButton, "scale", Vector2(1.3, 1.3), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_quit_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($QuitButton, "scale", Vector2(1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
