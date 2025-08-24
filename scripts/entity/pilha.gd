# PilhaColetavel.gd
extends Node3D # ou o tipo de corpo que você usa para colisão com o RayCast

# No Inspector, arraste o seu arquivo "pilha_item.tres" para este campo.
@export var item_data: ItemData

# Esta função será chamada pelo seu RayCast no player quando você apertar "interagir"
func interact():
	print("Interagindo com a pilha...")
	# Tentamos adicionar o item ao inventário.
	if Inventory.add_item(item_data):
		# Se o inventário conseguiu adicionar (retornou true), o item se destrói.
		queue_free()
	else:
		# Se o inventário retornou false, nada acontece com o item.
		# Opcional: você pode adicionar um som de "erro" ou uma mensagem na tela aqui.
		print("Não foi possível coletar a pilha (limite atingido ou inventário cheio).")
