extends Label3D

@onready var player_camera = get_viewport().get_camera_3d()

func _process(delta):
	if player_camera:
		var target = player_camera.global_transform.origin
		target.y = global_transform.origin.y
		look_at(target, Vector3.UP)
