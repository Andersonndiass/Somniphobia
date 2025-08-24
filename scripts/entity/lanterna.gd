# LanternaColetavel.gd
extends Node3D # Ou o tipo de corpo com colisão que você usa

# No Inspector, arraste o seu arquivo de recurso da Lanterna (.tres) para este campo.
@export var item_data: ItemData

# Esta função é chamada pelo RayCast do jogador ao pressionar "interagir"
func interact():
	# Tenta adicionar o item ao inventário
	if Inventory.add_item(item_data):
		# Se conseguiu (inventário não estava cheio), o objeto no chão desaparece.
		queue_free()
	else:
		# Se não conseguiu, avisa no console.
		print("Inventário cheio, não foi possível coletar a lanterna.")

# Esta função retorna o texto da dica para este item.
func get_interaction_text() -> String:
	# Verificamos se temos um ItemData válido.
	if item_data:
		# Formatamos a string para mostrar o nome e a tecla.
		return "Coletar %s [E]" % item_data.item_name
	# Se por algum motivo não houver ItemData, retornamos um texto padrão.
	return "Interagir [E]"
