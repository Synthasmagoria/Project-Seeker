extends Control

export(float) var cr_min_menu = 0.797
export(float) var cr_max_menu = 1.361
export(float) var cr_min_config = -0.45
export(float) var cr_max_config = 0.1
export(float) var time_speed_config = -1.0
export(float) var time_speed_menu = 0.0
var time_speed : float
var time : float
export(float) var duration = 1.0

var tween : SceneTreeTween

enum MODE {MENU, CONFIG}

func _process(delta: float) -> void:
	time += time_speed * delta
	for n in [$Pattern1, $Pattern2, $Pattern3, $Pattern4]:
		n.material.set_shader_param("time_add", time)

func set_mode(mode : int) -> void:
	var cr_min
	var cr_max
	var t_spd
	
	match mode:
		MODE.MENU:
			cr_min = cr_min_menu
			cr_max = cr_max_menu
			t_spd = time_speed_menu
		MODE.CONFIG:
			cr_min = cr_min_config
			cr_max = cr_max_config
			t_spd = time_speed_config
	
	if is_instance_valid(tween) && tween.is_running():
		tween.stop()
	tween = create_tween()
	tween.tween_property($ColorEffect.material, "shader_param/color_range_min", cr_min, duration)
	tween.parallel()
	tween.tween_property($ColorEffect.material, "shader_param/color_range_max", cr_max, duration)
	tween.parallel()
	tween.tween_property(self, "time_speed", t_spd, duration)
