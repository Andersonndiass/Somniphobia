# Enemy.gd
extends CharacterBody3D

# Velocidade do inimigo, pode ser ajustada no Inspector
@export var move_speed: float = 5.5

# Referências aos nós que vamos precisar
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var hitbox: Area3D = $Hitbox

# Variável para guardar a referência do jogador
var player_node: Node3D

func _ready():
	# Espera um pouco para garantir que o jogador já exista na cena
	await get_tree().create_timer(0.1).timeout
	# Procura pelo nó do jogador que está no grupo "player"
	player_node = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float):
	# Se por algum motivo não encontramos o jogador, não fazemos nada
	if not is_instance_valid(player_node):
		return
	
	# Define o alvo do nosso "GPS" para a posição atual do jogador
	nav_agent.target_position = player_node.global_position
	
	# Pega o próximo ponto do caminho calculado pelo GPS
	var next_path_position = nav_agent.get_next_path_position()
	
	# Calcula a direção do ponto atual até o próximo ponto do caminho
	var direction = global_position.direction_to(next_path_position)
	
	# Define a velocidade nessa direção
	velocity = direction * move_speed
	
	# Move o inimigo
	move_and_slide()

# Esta função é chamada AUTOMATICAMENTE quando algo entra na Hitbox
func _on_hitbox_body_entered(body):
	# Verificamos se o corpo que entrou é o jogador (verificando o grupo)
	if body.is_in_group("player"):
		print("INIMIGO TOCOU O JOGADOR! Fim de jogo.")
		# Desativa o inimigo para não dar múltiplos jumpscares
		set_physics_process(false)
		
		# --- AQUI A MÁGICA ACONTECE ---
		# Muda para a sua cena de jumpscare
		get_tree().change_scene_to_file("res://scenes/jumpscare.tscn") #<-- COLOQUE O CAMINHO CORRETO AQUI!


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$"../AudioStreamPlayer3".play()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		$"../AudioStreamPlayer3".stop()
