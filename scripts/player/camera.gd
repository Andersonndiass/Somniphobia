# camera_shake.gd
extends Node3D

@export var shake_enabled = true
@export var walk_shake_amount = 0.2
@export var walk_shake_speed = 8.0
@export var run_shake_amount = 0.5
@export var run_shake_speed = 12.0
@export var shake_smooth = 8.0

var shake_offset = Vector3.ZERO
var shake_time = 0.0
var current_shake_amount = 0.0
var current_shake_speed = 0.0
var is_moving = false
var is_running = false

func _process(delta):
	if !shake_enabled or !is_moving:
		shake_offset = shake_offset.lerp(Vector3.ZERO, delta * shake_smooth)
		transform.origin = shake_offset
		return

	shake_time += delta * current_shake_speed
	
	var x = sin(shake_time * 0.5) * current_shake_amount * 0.5
	var y = abs(sin(shake_time)) * current_shake_amount * 0.8
	var z = cos(shake_time * 0.3) * current_shake_amount * 0.2

	var target_offset = Vector3(x, y, z)

	shake_offset = shake_offset.lerp(target_offset, delta * shake_smooth)
	transform.origin = shake_offset

func set_running(running: bool):
	is_running = running
	update_shake_parameters()
	
func set_moving(moving: bool):
	is_moving = moving
	if !moving:
		shake_time = 0.0
	update_shake_parameters()

func update_shake_parameters():
	if is_running:
		current_shake_amount = run_shake_amount
		current_shake_speed = run_shake_speed
	elif is_moving:
		current_shake_amount = walk_shake_amount
		current_shake_speed = walk_shake_speed
	else:
		current_shake_amount = 0.0
		current_shake_speed = 0.0
