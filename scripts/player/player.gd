extends CharacterBody3D

# Configurações de movimento
@export var mouse_sensitivity = 0.1
@export var walk_speed = 5
@export var run_speed = 10
@export var jump_velocity = 7
@export var jump_force = 5

@onready var pause = $"../CanvasLayer"
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
	handle_mouse_mode()

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

func handle_mouse_mode():
	if Input.is_action_just_pressed("ui_cancel"):
		pause.visible = true
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			pause.visible = false
			
