# JumpscareScreen.gd
extends CanvasLayer

# Referências aos nossos nós
@onready var scare_image: TextureRect = $ScareImage
@onready var scare_sound: AudioStreamPlayer = $ScareSound
@onready var game_over_menu: VBoxContainer = $GameOverMenu

# A função _ready é chamada no exato instante em que a cena carrega
func _ready():
	game_over_menu.hide()
	# Garante que o mouse esteja visível para clicar nos botões
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AudioStreamPlayer.play()
	# --- O SUSTO ACONTECE AQUI ---
	# Mostra a imagem e toca o som imediatamente
	#scare_image.show()
	#scare_sound.play()
	
	# --- PREPARA O MENU DE GAME OVER ---
	# Espera por 1.5 segundos para o susto ter efeito
	await get_tree().create_timer(3).timeout
	
	game_over_menu.show()

# Função para o botão "Tentar Novamente"
func _on_try_again_button_pressed():
	GameManager.reset_game_state() # Reseta o jogo antes de recarregar a cena
	# Garante que o jogo esteja despausado antes de trocar de cena
	get_tree().paused = false
	# Recarrega sua cena principal do jogo
	get_tree().change_scene_to_file("res://scenes/menu.tscn") #<-- COLOQUE O CAMINHO DA SUA CENA PRINCIPAL AQUI!

# Função para o botão "Sair do Jogo"
func _on_quit_button_pressed():
	get_tree().quit()
