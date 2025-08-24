# ViewModel.gd
extends Node3D

var current_item_instance: Node3D = null

func _ready():
	# Conecta ao sinal de quando o jogador MUDA de slot
	Inventory.slot_selected.connect(_on_slot_selected)
	# --- NOVA LINHA ---
	# Conecta ao sinal de quando o inventário MUDA por qualquer motivo (pegar, usar, etc.)
	Inventory.inventory_changed.connect(update_display)
	
	# Garante que o item certo seja mostrado ao iniciar o jogo
	update_display()

# Função que mostra/esconde o item na mão
func show_item(item_data: ItemData):
	# Limpa o item que estava antes na mão
	if current_item_instance:
		current_item_instance.queue_free()
		current_item_instance = null
	
	# Se houver um novo item para mostrar (e ele tiver uma malha 3D)
	if item_data and item_data.mesh_scene:
		current_item_instance = item_data.mesh_scene.instantiate()
		add_child(current_item_instance)

# Esta função é chamada quando o jogador pressiona 1, 2 ou 3
func _on_slot_selected(_slot_index: int):
	update_display()

# --- NOVA FUNÇÃO CENTRAL ---
# Esta função lê o inventário e atualiza o que está na mão.
# Agora ela é chamada tanto ao trocar de slot quanto ao usar um item.
func update_display():
	# Pega o item que está no slot atualmente selecionado
	var item = Inventory.hotbar[Inventory.selected_slot]
	# Manda mostrar esse item (ou nada, se o slot estiver vazio)
	show_item(item)
