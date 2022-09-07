extends CurseState

var velocity : Vector2
var goal_velocity := Vector2(0, -100)
var acceleration_duration := 2.0
var _tween : SceneTreeTween

func enter() -> void:
	_tween = create_tween()
	_tween.tween_property(self, "velocity", goal_velocity, acceleration_duration)

func physics_process(delta : float) -> String:
	curse.position += velocity * delta
	curse.particles.global_position = hitbox.global_position
	return KEEP_STATE

func exit() -> void:
	if is_instance_valid(_tween):
		_tween.stop()
	_tween = null
