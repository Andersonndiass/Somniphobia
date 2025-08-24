extends Label

@onready var ray = $"/root/Node3D/Player/head/ShakeContainer/Camera3D/RayCast3D"

func _ready():
	# --- ADICIONE ESTAS DUAS LINHAS ---
	# Ouve o GameManager para se esconder quando o jogo pausa
	GameManager.returned_to_menu.connect(hide)
	GameManager.game_paused.connect(hide)
	# E para reaparecer quando o jogo resume
	GameManager.game_resumed.connect(show)
	# Garante que a label obedece ao pause
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	text = ""
	hide()

func _process(_delta):
	# Se o jogo está em exame (pause ativo), some
	if GameManager.is_exam_active or get_tree().paused:
		text = ""
		hide()
		return
	
	# Verifica se o ray encontrou algo
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj and obj.has_method("get_interaction_text"):
			text = obj.get_interaction_text()
			show()
		else:
			text = ""
			hide()
	else:
		text = ""
		hide()
