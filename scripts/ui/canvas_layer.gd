extends CanvasLayer

@onready var glitch_material = $ColorRect.material

func _process(delta):
	if randf() < 0.1: # 10% de chance por frame
		glitch_material.set("shader_param/glitch_strength", randf_range(1.0, 5.0))
	else:
		glitch_material.set("shader_param/glitch_strength", 0.0)
