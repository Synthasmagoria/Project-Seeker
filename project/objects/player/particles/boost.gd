extends Particles2D

onready var prev_position : Vector2 = position

func _process(delta : float) -> void:
#	process_material.set_shader_param("offset", (position - prev_position) * -1.0)
	prev_position = position
