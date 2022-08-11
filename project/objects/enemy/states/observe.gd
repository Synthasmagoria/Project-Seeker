extends EnemyState

var duration = 2.0
var observed = false

func enter() -> void:
	observed = false
	get_tree().create_timer(duration).connect("timeout", self, "_on_timeout")

func physics_process(delta : float) -> String:
	if observed:
		if enemy.player_close:
			return "WindUp"
		else:
			return "MoveTowardsPlayer"
	else:
		return KEEP_STATE

func _on_timeout() -> void:
	observed = true
