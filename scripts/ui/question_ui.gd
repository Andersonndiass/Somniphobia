# QuestionUI.gd
extends TextureRect

@onready var question_label: Label = $VBoxContainer/VBoxContainer/QuestionLabel
@onready var answers_container: VBoxContainer = $VBoxContainer/VBoxContainer/AnswersContainer

var current_subject: String
var correct_index: int

func _ready():
	# --- LINHA DA CORREÇÃO ---
	# Esta linha garante que este nó continue processando inputs (como a tecla ESC)
	# mesmo quando o jogo está pausado com get_tree().paused = true.
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	GameManager.show_question_requested.connect(display_question)
	hide()

func _unhandled_input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		print("ESC Pressionado na QuestionUI! Consumindo o input.")
		# Esta linha é CRUCIAL. Ela impede que o Player ouça este mesmo aperto de tecla.
		get_tree().get_root().set_input_as_handled()
		close_ui()

func display_question(subject: String, question: String, answers: Array, correct_answer_idx: int):
	GameManager.start_exam()
	current_subject = subject
	correct_index = correct_answer_idx
	for child in answers_container.get_children():
		child.queue_free()
	
	question_label.text = question
	
	for i in range(answers.size()):
		var button = Button.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.text = answers[i]
		button.clip_text = false  # deixa o texto passar pra próxima linha se couber
		button.pressed.connect(_on_answer_pressed.bind(i))
		answers_container.add_child(button)
		button.flat = true
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		button.add_theme_color_override("font_color", Color.BLACK)
		show()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_answer_pressed(index_pressed: int):
	if index_pressed == correct_index:
		GameManager.complete_quest(current_subject)
	
	close_ui()

func close_ui():
	GameManager.finish_exam()
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
