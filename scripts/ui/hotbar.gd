extends HBoxContainer

const MENU_SCENE_PATH := "res://scenes/menu.tscn" # ajuste se o caminho for outro

var slots: Array

func _ready():
	add_to_group("ui_hotbar") # vamos poder esconder/mostrar pelo menu/jogo
	_apply_visibility_for_current_scene()

	get_slots()
	Inventory.inventory_changed.connect(_update_hotbar)
	Inventory.slot_selected.connect(_highlight_slot)
	_update_hotbar()

func _apply_visibility_for_current_scene():
	var cs := get_tree().current_scene
	var is_menu := cs != null and (
		cs.get_scene_file_path() == MENU_SCENE_PATH  # por caminho
		or cs.name == "menu"                         # fallback por nome
	)
	visible = not is_menu

func get_slots():
	slots = get_children()
	for slot: TextureButton in slots:
		slot.pressed.connect(Inventory.select_slot.bind(slot.get_index()))

# Em hotbar.gd

# VERSÃO FINAL E SEGURA (para qualquer versão do Godot)
func _update_hotbar():
	# Percorremos cada slot da hotbar
	for slot: TextureButton in slots:
		# Pegamos o item correspondente no inventário
		var item = Inventory.hotbar[slot.get_index()]
		# Pegamos o Label no caminho correto
		var quantity_label: Label = slot.get_node("QuantityLabel")

		# Se o nó Label não for encontrado, pulamos para o próximo slot
		if not quantity_label:
			continue

		# Se EXISTE um item neste slot...
		if item:
			slot.texture_normal = item.icon
			
			if item.is_stackable:
				# A única coisa que o código faz é definir o texto e mostrar o Label
				quantity_label.text = str(item.quantity)
				quantity_label.show()
			else:
				# Se não for empilhável, apenas esconde
				quantity_label.hide()
		# Se o slot estiver VAZIO...
		else:
			slot.texture_normal = null
			quantity_label.hide()

func _highlight_slot(slot_index: int):
	for i in range(min(3, slots.size())):
		slots[i].modulate = Color(1,1,1)
	slots[slot_index].modulate = Color(1.5, 1.5, 1.5)
