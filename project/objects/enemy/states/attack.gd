extends EnemyState

var attack_distance := 160.0
var attack_duration := 0.5
var finished = false

func enter() -> void:
	finished = false
	var _player = NodeUtil.get_first_node_in_group_in_current_level("player")
	var _direction = enemy.global_position.direction_to(_player.global_position)
	var _tween = create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.tween_property(enemy, "global_position", enemy.global_position + _direction * attack_distance, attack_duration)
	_tween.connect("finished", self, "_on_attack_finished")

func physics_process(delta : float) -> String:
	if finished:
		return "MoveTowardsPlayer"
	else:
		return KEEP_STATE

func _on_attack_finished() -> void:
	finished = true
