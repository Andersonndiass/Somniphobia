# Inventory.gd
extends Node

signal inventory_changed
signal slot_selected(slot_index: int)
signal flashlight_acquired

const HOTBAR_SIZE := 3
var hotbar: Array[ItemData]
var selected_slot: int = 0
const PILULA_ITEM = preload("res://Tools/pilula.tres") 

func _ready():
	GameManager.all_quests_completed.connect(_on_all_quests_completed)

func _init():
	hotbar.resize(HOTBAR_SIZE)
	hotbar.fill(null)

# --- FUNÇÃO add_item COM A NOVA TRAVA ---
func add_item(item_data: ItemData) -> bool:
	# --- INÍCIO DA NOVA VERIFICAÇÃO ---
	# Se o item for empilhável, primeiro verificamos o total que já temos.
	if item_data.is_stackable:
		var total_existente = get_item_count(item_data.item_name)
		# Se o total que já temos for igual ou maior que o limite máximo do stack...
		if total_existente >= item_data.max_stack_size:
			print("Limite total para o item '", item_data.item_name, "' atingido!")
			return false # ...bloqueamos a coleta e retornamos 'false'.
	# --- FIM DA NOVA VERIFICAÇÃO ---

	# Se o item for empilhável (e passou na verificação acima)...
	if item_data.is_stackable:
		# 1. Tenta encontrar um slot com o mesmo item que não esteja cheio
		for i in range(HOTBAR_SIZE):
			var slot_item = hotbar[i]
			if slot_item and slot_item.item_name == item_data.item_name and slot_item.quantity < slot_item.max_stack_size:
				slot_item.quantity += 1
				inventory_changed.emit()
				return true
		
		# 2. Se não encontrou, procura um slot vazio para iniciar uma nova pilha
		for i in range(HOTBAR_SIZE):
			if hotbar[i] == null:
				hotbar[i] = item_data.duplicate()
				hotbar[i].quantity = 1
				inventory_changed.emit()
				select_slot(i)
				return true
	
	# Se o item NÃO for empilhável...
	else:
		for i in range(HOTBAR_SIZE):
			if hotbar[i] == null:
				hotbar[i] = item_data
				if item_data.is_flashlight:
					flashlight_acquired.emit()
				inventory_changed.emit()
				select_slot(i)
				return true

	print("Inventário Cheio!")
	return false

# ... (o resto do script, remove_item, get_item_count, etc. continua igual) ...

func remove_item(item_name: String, amount: int) -> bool:
	for i in range(HOTBAR_SIZE - 1, -1, -1):
		var slot_item = hotbar[i]
		if slot_item and slot_item.item_name == item_name:
			slot_item.quantity -= amount
			if slot_item.quantity <= 0:
				hotbar[i] = null
			inventory_changed.emit()
			return true
	return false

func get_item_count(item_name: String) -> int:
	var total_count = 0
	for slot_item in hotbar:
		if slot_item and slot_item.item_name == item_name:
			total_count += slot_item.quantity
	return total_count

func select_slot(index: int):
	selected_slot = clamp(index, 0, HOTBAR_SIZE - 1)
	slot_selected.emit(selected_slot)
	
func _on_all_quests_completed():
	print("Recebendo a pílula da vitória!")
	# Adiciona a pílula ao inventário do jogador
	add_item(PILULA_ITEM)
	# Você pode adicionar um som ou uma mensagem na tela aqui também
	
func reset():
	# Limpa a lista da hotbar
	hotbar.clear()
	# Garante que a hotbar tenha o tamanho certo, mas com slots vazios (null)
	hotbar.resize(HOTBAR_SIZE) 
	# Reinicia o slot selecionado
	selected_slot = 0
	# Emite o sinal para que a UI visual da hotbar também se limpe
	inventory_changed.emit()
	print("Inventário resetado!")
