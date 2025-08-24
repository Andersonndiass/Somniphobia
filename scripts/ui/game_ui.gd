# game_ui.gd (versão final corrigida)
extends CanvasLayer

@onready var battery_bar: ProgressBar = $ProgressBar
@onready var stamina_bar: ProgressBar = $StaminaBar
var player: CharacterBody3D

# Declara as variáveis de estilo. Elas serão inicializadas no _ready.
var battery_fill_style: StyleBoxFlat
var stamina_fill_style: StyleBoxFlat

# Cores que vamos usar
var color_normal = Color("#9ACD32") # Amarelo-esverdeado para bateria
var color_perigo = Color("#FF4136") # Vermelho

func _ready():
	# --- PARTE CORRIGIDA ---
	# Pega o estilo da bateria, duplica-o e atribui a cópia única de volta à barra.
	battery_fill_style = battery_bar.get_theme_stylebox("fill").duplicate()
	battery_bar.add_theme_stylebox_override("fill", battery_fill_style)
	
	# Faz o mesmo para a barra de stamina, garantindo que ela seja independente.
	stamina_fill_style = stamina_bar.get_theme_stylebox("fill").duplicate()
	stamina_bar.add_theme_stylebox_override("fill", stamina_fill_style)

	# Agora podemos dar uma cor padrão diferente para a stamina com segurança.
	stamina_fill_style.bg_color = Color("#4CAF50") # Verde
	# --- FIM DA CORREÇÃO ---

	GameManager.returned_to_menu.connect(hide)
	GameManager.game_paused.connect(hide)
	GameManager.game_resumed.connect(show)
	GameManager.exam_started.connect(hide)
	GameManager.exam_finished.connect(show)
	
	call_deferred("_connect_player")

func _connect_player():
	player = get_tree().get_first_node_in_group("player")
	if is_instance_valid(player):
		player.battery_updated.connect(_on_player_battery_updated)
		player.stamina_updated.connect(_on_player_stamina_updated)
	else:
		push_error("UI não conseguiu encontrar o Player!")

func _on_player_battery_updated(current_value: float, max_value: float):
	battery_bar.max_value = max_value
	battery_bar.value = current_value
	
	var percent = 0.0
	if max_value > 0: percent = current_value / max_value
	
	# Esta mudança de cor agora afeta APENAS a barra de bateria.
	if percent <= 0.25:
		battery_fill_style.bg_color = color_perigo
		if percent < 0.1:
			battery_bar.modulate.a = randf_range(0.4, 1.0)
		else:
			battery_bar.modulate.a = 1.0
	else:
		battery_fill_style.bg_color = color_normal
		battery_bar.modulate.a = 1.0

func _on_player_stamina_updated(current_value: float, max_value: float):
	stamina_bar.max_value = max_value
	stamina_bar.value = current_value
	
	if current_value >= max_value:
		stamina_bar.visible = false
	else:
		stamina_bar.visible = true
