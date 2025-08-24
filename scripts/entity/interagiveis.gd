# interagiveis.gd
extends RigidBody3D

@export var item_data: ItemData

func _ready():
	# A única coisa que fica aqui é o nome, que é seguro de acessar
	if item_data:
		name = item_data.item_name
	
	# Agora chamamos a função de spawn de forma "atrasada" (deferred)
	call_deferred("spawn_visuals")

# NOVA FUNÇÃO QUE CRIAMOS
func spawn_visuals():
	# Esta nova função faz o que o _ready() fazia antes, mas de forma segura
	if item_data and item_data.mesh_scene:
		spawn_item_with_collision(item_data.mesh_scene)
	else:
		# Uma mensagem de erro mais clara caso algo ainda esteja vazio
		print("ERRO: ItemData ou Mesh Scene está vazio para o item: ", name)

# ... resto do seu código (interact, spawn_item_with_collision, etc.) ...
# Não mude mais nada, apenas a função _ready() e adicione a spawn_visuals()

# Função chamada pelo RayCast do jogador
func interact():
	if Inventory.add_item(item_data):
		# Usamos call_deferred para garantir que a remoção seja segura
		call_deferred("queue_free")
	else:
		print("Inventário cheio para o item: ", item_data.item_name)

# --- Suas funções avançadas para criar colisão ---
# (Mantidas exatamente como você fez, pois são ótimas)
func spawn_item_with_collision(scene) -> Node3D:
	var inst = scene.instantiate()
	add_child(inst)

	var mesh_instance = find_first_mesh_instance(inst)
	if mesh_instance and mesh_instance.mesh:
		mesh_instance.force_update_transform()
		var shape = mesh_instance.mesh.create_convex_shape()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = shape
		add_child(col_shape)
		col_shape.global_transform = mesh_instance.global_transform
	return inst

func find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_first_mesh_instance(child)
		if result:
			return result
	return null

func get_interaction_text() -> String:
	# Verificamos se temos um ItemData válido.
	if item_data:
		# Formatamos a string para mostrar o nome e a tecla de interação.
		return "Coletar %s [E]" % item_data.item_name
	# Se não houver ItemData, retornamos um texto padrão.
	return "Interagir [E]"
