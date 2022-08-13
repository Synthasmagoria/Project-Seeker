extends EnemyState

onready var sprite = $"../../AnimatedSprite"
var attack_distance := 160.0
var attack_duration := 0.5
var direction : float
var finished = false

func enter() -> void:
	finished = false
	var _direction = enemy.global_position.direction_to(Game.player.global_position)
	var _tween = create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.tween_property(enemy, "global_position", enemy.global_position + _direction * attack_distance, attack_duration)
	_tween.connect("finished", self, "_on_attack_finished")
	sprite.play("move")
	sprite.flip_h = _direction.x < 0.0
	sprite.speed_scale = 2.0

func physics_process(delta : float) -> String:
	if finished:
		return "MoveTowardsPlayer"
	else:
		return KEEP_STATE

func exit() -> void:
	sprite.speed_scale = 1.0

func _on_attack_finished() -> void:
	finished = true
