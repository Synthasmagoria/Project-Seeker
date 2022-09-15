extends Sprite

onready var spawner = $CurseSpawner

func _process(delta: float) -> void:
	var mat = material as ShaderMaterial
	mat.set_shader_param("fill", 1.0 - pow(spawner.timer.time_left / spawner.interval, 2.0))
