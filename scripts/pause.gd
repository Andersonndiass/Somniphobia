extends Control


# Called when the node enters the scene tree for the first time.
func resume():
	get_tree().paused = false
	
func pause():
	get_tree().paused = true
	
func teclaEsq():
	if Input.is_action_just_pressed("esq") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esq") and get_tree().paused:
		resume()
		
func _physics_process(delta: float) -> void:
	teclaEsq()
