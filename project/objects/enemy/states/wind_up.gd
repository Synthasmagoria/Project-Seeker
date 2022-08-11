extends EnemyState

var wound_up = false
var wind_up_time = 1.0

func enter() -> void:
	wound_up = false
	var _tween = get_tree().create_timer(wind_up_time).connect("timeout", self, "_on_wind_up_timeout")

func _on_wind_up_timeout() -> void:
	wound_up = true

func physics_process(delta : float) -> String:
	if wound_up:
		return "Attack"
	else:
		return KEEP_STATE
