extends Camera3D

@onready var player = $"../.."
@export var shake_enabled = true
@export var run_shake_amount = 0.5  # Aumentado para ter mais impacto visual
@export var run_shake_speed = 12.0   # Frequência do shake (passos por segundo)
@export var run_shake_smooth = 8.0   # Suavização da interpolação

var shake_offset = Vector3.ZERO
var shake_time = 0.0
var is_running = false

func _process(delta):
	if !shake_enabled or !is_running:
		shake_offset = shake_offset.lerp(Vector3.ZERO, delta * run_shake_smooth)
		transform.origin = shake_offset
		return

	# Tempo avançando
	shake_time += delta * run_shake_speed
	
	# Movimento senoidal imitando passos (vertical + horizontal leve)
	var x = sin(shake_time * 0.5) * run_shake_amount * 0.5
	var y = abs(sin(shake_time)) * run_shake_amount  # movimento vertical sempre para cima
	var z = 0  # geralmente não há shake no eixo Z ao correr

	var target_offset = Vector3(x, y, z)

	# Suavização da interpolação para deixar natural
	shake_offset = shake_offset.lerp(target_offset, delta * run_shake_smooth)
	transform.origin = shake_offset

func set_running(running: bool):
	is_running = running
	if !running:
		shake_time = 0.0
