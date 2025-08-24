extends CharacterBody3D

<<<<<<< HEAD
# --- REFERÊNCIAS DE NÓS ---
@export var pause_menu: Control
@export var ray_cast: RayCast3D
@onready var head: Node3D = $head
@onready var camera_shake = $head/ShakeContainer
# --- NOVA LINHA ---
# Conexão com o Label de dica na UI. Verifique se o caminho $UI/InteractionLabel está correto!
@onready var interaction_label: Label = $UI/InteractionLabel

@export_group("Stamina")
@export var max_stamina: float = 100.0
@export var stamina_drain_rate: float = 17.0 # Pontos por segundo ao correr
@export var stamina_regen_rate: float = 10.5 # Pontos por segundo ao descansar
var current_stamina: float
var can_sprint: bool = true
# --- BATERIA DA LANTERNA ---
@export_group("Bateria da Lanterna")
@export var max_battery: float = 100.0
@export var battery_drain_rate: float = 2.0
@export var battery_recharge_value: float = 35.0
var current_battery
signal stamina_updated(current_value: float, max_value: float)

# --- MOVIMENTO E CÂMERA ---
@export_group("Movimento")
@export var mouse_sensitivity := 0.1
@export var walk_speed := 5.0
@export var run_speed := 10.0
@export var jump_velocity := 4.5
@export var gravity: float = 9.8

var current_speed := 5.0
var run := false
var rotation_x := 0.0
var rotation_y := 0.0
const MIN_X_ROTATION := -90.0
const MAX_X_ROTATION := 90.0


# --- ESTADO DA LANTERNA ---
var tem_lanterna := false
var is_holding_flashlight: bool = false
var lanterna: SpotLight3D = null
signal battery_updated(current_value: float, max_value: float)


# --- FUNÇÕES DO GODOT ---

func _ready():
	add_to_group("player") # <--- ESSA LINHA É ESSENCIAL
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_stamina = max_stamina
	current_speed = walk_speed
	current_battery = max_battery
	Inventory.flashlight_acquired.connect(_on_flashlight_acquired)
	Inventory.slot_selected.connect(_on_slot_changed)
	GameManager.exam_started.connect(_on_exam_started)   # <--- NOVO
	GameManager.exam_finished.connect(_on_exam_finished) # <--- NOVO
	get_tree().call_group("ui_hotbar", "show")


func _input(event):
	# Movimento do mouse
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, MIN_X_ROTATION, MAX_X_ROTATION)
		rotation_degrees.y = rotation_y
		head.rotation_degrees.x = rotation_x

	# Ação para ligar/desligar a lanterna (Tecla "lanterna", ex: F)
	if event.is_action_pressed("lanterna") and is_holding_flashlight and current_battery > 0:
		if GameManager.is_exam_active: # <--- trava durante exame
			return
		if is_instance_valid(lanterna):
			lanterna.visible = not lanterna.visible
		else:
			print("ERRO: Tentou ligar a lanterna, mas a referência da SpotLight3D não foi encontrada!")

	# Ação para USAR a pilha (Tecla "use_item", ex: Clique Direito)
	if event.is_action_pressed("lanterna"):
		var item_selecionado = Inventory.hotbar[Inventory.selected_slot]
		# Verifica se o jogador está segurando um item e se esse item é usável
		if item_selecionado and item_selecionado.is_usable:
			# Se for o item de vitória, termina o jogo
			if item_selecionado.is_victory_item:
				end_game()
			# Se for uma pilha, usa a pilha
			elif item_selecionado.item_name == "pilha":
				use_battery_pack()
			
			# Remove o item após o uso (se ele não for empilhável)
			if not item_selecionado.is_stackable:
				Inventory.remove_item(item_selecionado.item_name, 1)
	# Seleção da Hotbar
	if event.is_action_pressed("hot_bar1"):
		Inventory.select_slot(0)
	elif event.is_action_pressed("hot_bar2"):
		Inventory.select_slot(1)
	elif event.is_action_pressed("hot_bar3"):
		Inventory.select_slot(2)


func _physics_process(delta: float):
	_update_stamina(delta)
	handle_movement(delta)
	handle_sprint()
	handle_interaction()
	_update_battery(delta)

func _process(_delta):
	pass

func _unhandled_input(event):
	# Se a tecla ESC for pressionada E NÃO FOI CONSUMIDA PELA QUESTIONUI...
	if event.is_action_pressed("ui_cancel"):
		# ...então podemos abrir/fechar o menu de pause.
		if not GameManager.is_exam_active:
			toggle_pause()
# --- ADICIONE ESTA NOVA FUNÇÃO ---
# --- SUBSTITUA A SUA FUNÇÃO toggle_pause POR ESTA VERSÃO MAIS SIMPLES ---
func toggle_pause():
	# Verifica se o jogo já está pausado para decidir qual função chamar
	if get_tree().paused:
		GameManager.resume_game()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		GameManager.pause_game()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# --- LÓGICAS PRINCIPAIS ---
func handle_movement(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir := Input.get_vector("esq", "dir", "cima", "baixo")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	move_and_slide()
	
	var is_moving_on_ground = direction != Vector3.ZERO and is_on_floor()
	# 🔊 Controle do som dos passos
	if is_moving_on_ground:
		if run:
			$"../AudioStreamPlayer2".pitch_scale = 1.3 # mais rápido
		else:
			$"../AudioStreamPlayer2".pitch_scale = 1.0
		if not $"../AudioStreamPlayer2".playing:
			$"../AudioStreamPlayer2".play()
	else:
		$"../AudioStreamPlayer2".stop()
	# Câmera tremer só quando mexe
	if camera_shake:
		camera_shake.set_moving(is_moving_on_ground)

func handle_sprint():
	var is_moving_input = Input.is_action_pressed("cima") or Input.is_action_pressed("baixo") or Input.is_action_pressed("esq") or Input.is_action_pressed("dir")
	# Adicionamos a verificação "and can_sprint"
	run = Input.is_action_pressed("corre") and is_moving_input and can_sprint
	current_speed = run_speed if run else walk_speed
	if camera_shake:
		camera_shake.set_running(run)


# --- SUBSTITUA SUA FUNÇÃO handle_interaction POR ESTA ---
func handle_interaction():
	# Se a UI de perguntas estiver visível, não fazemos mais nada aqui
	var question_ui = $UI/QuestionUI #<-- VERIFIQUE ESTE CAMINHO!
	if question_ui.visible:
		interaction_label.hide() # Esconde a dica se a UI de pergunta estiver aberta
		return

	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		
		if collider and collider.is_in_group("interagivel"):
			if collider.has_method("get_interaction_text"):
				interaction_label.text = collider.get_interaction_text()
				interaction_label.show()
			
			if Input.is_action_just_pressed("interagir"):
				collider.interact()
			
			return
			
	interaction_label.hide()


func _update_battery(delta: float):
	if is_instance_valid(lanterna) and lanterna.visible:
		current_battery -= battery_drain_rate * delta
		if current_battery <= 0:
			current_battery = 0
			lanterna.visible = false
	battery_updated.emit(current_battery, max_battery)


# --- FUNÇÕES DE CALLBACK E ITENS ---

func _on_flashlight_acquired():
	if tem_lanterna: return
	tem_lanterna = true
	print("Lanterna adquirida!")


func _on_slot_changed(slot_index: int):
	if not tem_lanterna: return
	
	var item = Inventory.hotbar[slot_index]
	
	if item and item.is_flashlight:
		is_holding_flashlight = true
		await get_tree().create_timer(0.01).timeout
		
		var view_model = $head/ShakeContainer/Camera3D/Viewmodel
		
		if view_model and view_model.current_item_instance:
			lanterna = view_model.current_item_instance.find_child("SpotLight3D", true, false)
			if is_instance_valid(lanterna):
				print("Referência da SpotLight3D encontrada com sucesso!")
			else:
				print("AVISO: Lanterna selecionada, mas a SpotLight3D não foi encontrada no modelo!")
		else:
			print("AVISO: O nó Viewmodel ou o modelo do item não foram encontrados.")
			lanterna = null
	else:
		is_holding_flashlight = false
		if is_instance_valid(lanterna):
			lanterna.visible = false
		lanterna = null


func use_battery_pack():
	if current_battery >= max_battery:
		print("Bateria já está cheia.")
		return

	if Inventory.get_item_count("pilha") > 0:
		if Inventory.remove_item("pilha", 1):
			current_battery += battery_recharge_value
			current_battery = min(current_battery, max_battery)
			print("Pilha usada! Bateria atual: ", current_battery)
	else:
		print("Sem pilhas para usar.")
# Quando o exame começar → apaga a lanterna
func _on_exam_started():
	if is_instance_valid(lanterna):
		lanterna.visible = false

# Quando o exame terminar → não liga automaticamente, apenas libera o uso novamente
func _on_exam_finished():
	# Aqui você pode decidir se a lanterna volta ligada ou só fica pronta para ser ligada
	# Vou deixar apenas disponível, mas desligada
	if is_instance_valid(lanterna):
		lanterna.visible = false

func end_game():
	print("O jogador usou a pílula. Fim de jogo!")
	# Pausa o jogo para garantir que nada mais aconteça
	get_tree().paused = true
	# Muda para a sua nova cena de vitória
	get_tree().change_scene_to_file("res://scenes/vitoria.tscn") #<-- CRIE ESTA CENA!
func _update_stamina(delta: float):
	if run:
		# Gasta stamina se estiver correndo
		current_stamina -= stamina_drain_rate * delta
		if current_stamina <= 0:
			can_sprint = false # Bloqueia a corrida
	else:
		# Regenera stamina se não estiver correndo
		current_stamina += stamina_regen_rate * delta
		# Permite voltar a correr quando a stamina atingir um certo nível (ex: 20%)
		if current_stamina > max_stamina * 0.2:
			can_sprint = true
	
	# Garante que a stamina não passe dos limites 0 e max_stamina
	current_stamina = clamp(current_stamina, 0.0, max_stamina)
	
	# Avisa a UI sobre a mudança na stamina
	stamina_updated.emit(current_stamina, max_stamina)
=======
# Configurações de movimento
@export var mouse_sensitivity = 0.1
@export var walk_speed = 5
@export var run_speed = 10
@export var jump_velocity = 7
@export var jump_force = 5


# Referências de nó
@onready var camera_pivot = $head
@onready var camera = $head/Camera3D

# Variáveis de estado
enum PlayerState { IDLE, WALKING, RUNNING, JUMPING, FALLING }
var current_state = PlayerState.IDLE
var rotation_x = 0
var rotation_y = 0
var current_speed = walk_speed

# Limites de rotação da câmera
const MIN_X_ROTATION = -45  
const MAX_X_ROTATION = 40  

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_movement(event)

func _physics_process(delta: float) -> void:
	update_state()
	handle_state(delta)
	move_and_slide()

func _process(delta):
	pass
func update_state():
	var input_vector = Input.get_vector("esq", "dir", "cima", "baixo")
	var is_moving = input_vector.length() > 0
	
	if not is_on_floor():
		if velocity.y > 0:
			current_state = PlayerState.JUMPING
		else:
			current_state = PlayerState.FALLING
	elif is_moving:
		if Input.is_action_pressed("corre"):
			current_state = PlayerState.RUNNING
		else:
			current_state = PlayerState.WALKING
	else:
		current_state = PlayerState.IDLE

func handle_state(delta):
	match current_state:
		PlayerState.IDLE:
			handle_idle(delta)
		PlayerState.WALKING:
			handle_walking(delta)
		PlayerState.RUNNING:
			handle_running(delta)
		PlayerState.JUMPING:
			handle_jumping(delta)
		PlayerState.FALLING:
			handle_falling(delta)

# Handlers de estado
func handle_idle(delta):
	current_speed = walk_speed
	velocity.x = move_toward(velocity.x, 0, current_speed)
	velocity.z = move_toward(velocity.z, 0, current_speed)

func handle_walking(delta):
	current_speed = walk_speed
	handle_movement(delta)
	camera.set_running(false)
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	current_state = PlayerState.JUMPING

func handle_running(delta):
	current_speed = run_speed
	handle_movement(delta)
	if camera.has_method("set_running"):
		camera.set_running(true)
	else:
		camera.set_running(false)
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
		current_state = PlayerState.JUMPING

func handle_jumping(delta):
	handle_movement(delta)
	velocity.y -= 9.8 * delta

func handle_falling(delta):
	handle_movement(delta)
	velocity.y -= 9.8 * delta

# Funções auxiliares
func handle_movement(delta):
	var input_dir = Input.get_vector("esq", "dir", "cima", "baixo")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed

func handle_mouse_movement(event):
	rotation_y -= event.relative.x * mouse_sensitivity
	rotation_x -= event.relative.y * mouse_sensitivity 
	rotation_x = clamp(rotation_x, MIN_X_ROTATION, MAX_X_ROTATION)
	rotation_degrees.y = rotation_y
	camera_pivot.rotation_degrees.x = rotation_x
>>>>>>> 74b14751a69565a81a3bfd770c9cd936a7608304
