# pointer.gd
extends ColorRect # ou o tipo de nó que o seu Pointer for (TextureRect, etc)

func _ready():
	# Conecta diretamente aos sinais do GameManager para se esconder/mostrar
	GameManager.exam_started.connect(hide)
	GameManager.exam_finished.connect(show)
