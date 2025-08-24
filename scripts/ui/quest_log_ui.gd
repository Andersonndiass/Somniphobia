extends Panel

@onready var quest_container: VBoxContainer = $VBoxContainer

func _ready():
	GameManager.quest_updated.connect(_update_single_quest)
	GameManager.returned_to_menu.connect(hide)
	_update_all_quests()
	
func _update_all_quests():
	var all_status = GameManager.get_all_quests_status()
	for subject in all_status:
		_update_quest_text(subject, all_status[subject])

func _update_single_quest(subject_name: String):
	var status = GameManager.get_quest_status(subject_name)
	_update_quest_text(subject_name, status)

func _update_quest_text(subject_name: String, is_completed: bool):
	var label_node: Label = quest_container.get_node(subject_name + "_label")
	if label_node:
		label_node.text = subject_name.capitalize()
		if is_completed:
			label_node.add_theme_color_override("font_color", Color("green"))
		else:
			label_node.add_theme_color_override("font_color", Color("red"))
