extends RigidBody3D

@onready var spotlight: SpotLight3D = $SpotLight3D
@export_group("Dados da Quest")
@export var subject: String = "matematica"
@export_multiline var question_text: String = "Pergunta Padrão?"
@export var answers: Array[String] = ["Resposta A", "Resposta B"]
@export var correct_answer_index: int = 0

func _ready():
	add_to_group("interagivel")
	GameManager.quest_updated.connect(_on_quest_completed)

func interact():
	if not GameManager.get_quest_status(subject):
		GameManager.show_question(subject, question_text, answers, correct_answer_index)
	else:
		print("Missão de '", subject, "' já foi concluída.")

func get_interaction_text() -> String:
	# Se o exame está ativo, não mostra nada
	if GameManager.is_exam_active:
		return ""
	
	if not GameManager.get_quest_status(subject):
		return "Examinar Nota [E]"
	else:
		return "Nota de '%s' (Concluído)" % subject.capitalize()
	
func _on_quest_completed(updated_subject: String):
	if updated_subject == subject:   # aqui é subject, não subject_name
		spotlight.visible = false    # apaga a luz
		queue_free()
