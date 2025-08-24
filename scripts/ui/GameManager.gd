extends Node

signal quest_updated(subject_name)
signal show_question_requested(subject, question, answers, correct_index)
signal exam_started
signal exam_finished
var is_exam_active: bool = false
signal all_quests_completed
signal game_paused
signal game_resumed
signal returned_to_menu

var quest_status := {
	"matematica": false, "fisica": false, "portugues": false,
	"geografia": false, "historia": false, "quimica": false
}

func complete_quest(subject_name: String):
	if quest_status.has(subject_name):
		quest_status[subject_name] = true
		quest_updated.emit(subject_name)
		_check_for_victory()

func _check_for_victory():
	for subject in quest_status:
		if not quest_status[subject]:
			# Se encontrar qualquer missão incompleta, sai da função.
			return
	
	# Se o loop terminar sem encontrar nenhuma missão incompleta, significa que o jogador venceu.
	print("TODAS AS MISSÕES FORAM CONCLUÍDAS!")
	all_quests_completed.emit()

func get_quest_status(subject_name: String) -> bool:
	return quest_status.get(subject_name, false)

func get_all_quests_status() -> Dictionary:
	return quest_status

func show_question(subject: String, question: String, answers: Array, correct_index: int):
	show_question_requested.emit(subject, question, answers, correct_index)

# Função para anunciar que a tela de pergunta está abrindo
func start_exam():
	is_exam_active = true
	exam_started.emit()

# Função para anunciar que a tela de pergunta está fechando
func finish_exam():
	is_exam_active = false
	exam_finished.emit()

func pause_game():
	get_tree().paused = true
	game_paused.emit()

func resume_game():
	get_tree().paused = false
	game_resumed.emit()

func reset_game_state():
	# Reinicia o status de todas as missões para 'false'
	quest_status = {
		"matematica": false, "fisica": false, "portugues": false,
		"geografia": false, "historia": false, "quimica": false
	}
	is_exam_active = false
	
	# Chama a função de reset de outros Autoloads
	Inventory.reset()
	
	print("Estado do jogo resetado!")
