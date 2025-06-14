extends CharacterBody3D
var rotation_x = 0
var rotation_y = 0
@export var mouse_sensitivity = 0.1
@onready var camera_pivot = $head
@onready var camera = $head/Camera3D
var SPEED = 5
const JUMP_VELOCITY = 7
const jump_force = 5
var run = false
var walk_speed = 5
var run_speed = 10
var current_speed = walk_speed

const MIN_X_ROTATION = -45  
const MAX_X_ROTATION = 40  

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
	# Rotação horizontal (personagem e câmera)
		rotation_y -= event.relative.x * mouse_sensitivity
		# Rotação vertical (apenas câmera)
		rotation_x -= event.relative.y * mouse_sensitivity 
		
		rotation_x = clamp(rotation_x, MIN_X_ROTATION, MAX_X_ROTATION)
		# Aplica as rotações
		rotation_degrees.y = rotation_y
		camera_pivot.rotation_degrees.x = rotation_x

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_sprint()

func handle_movement(delta):
	var input_dir = Input.get_vector("esq", "dir", "cima", "baixo")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0,current_speed)

	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()
	
func handle_sprint():
	if Input.is_action_pressed("corre") and Input.get_vector("cima", "baixo", "esq", "dir").length() > 0:
		run = true
		current_speed = run_speed
		if camera.has_method("set_running"):
			camera.set_running(true)
	else:
		run = false
		current_speed = walk_speed 
		if camera.has_method("set_running"):
			camera.set_running(false)

func _process(delta):
	# Controle do mouse (ESC para liberar/capturar)
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
