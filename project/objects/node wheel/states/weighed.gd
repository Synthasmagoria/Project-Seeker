extends WheelState

class_name WheelStateWeighed

## The significance to momentum of the weight put onto the the wheel's platforms by the player
export(float, 0.1, 5.0) var weight_factor = 2.0
## The rate at which the wheel slows its rotation
export(float, 0.1, 5.0) var friction = 1.0
## Reference to the player
var _player : KinematicBody2D
## Reference to the weighed platform
var _weighed_platform : KinematicBody2D
## Dash multiplier
var dash_multiplier := 60.0

func init(args) -> void:
	.init(args)
	connect_to_player(Game.player)

func connect_to_player(play) -> void:
	if play:
		play.connect("entered_platform", self, "_on_player_entered_platform", [play])
		play.connect("exited_platform", self, "_on_player_exited_platform", [play])

func get_platform_weight(plat : KinematicBody2D, play : KinematicBody2D, factor : float) -> float:
	if is_instance_valid(plat):
		var _plat_up = Math.rotate_v2_90cc(plat.position).normalized()
		var _regular_weight = play.up.dot(_plat_up) * factor
		var _frame_weight = _regular_weight + _regular_weight * dash_multiplier * float(_player.platform_dashed)
		_player.platform_dashed = false
		return _frame_weight
	else:
		return 0.0

func adjust_angular_velocity_for_friction(av : float, fric : float) -> float:
	return max(abs(av) - fric, 0.0) * sign(av)

func calculate_angular_velocity(_av) -> float:
	var _frame_weight = get_platform_weight(_weighed_platform, _player, weight_factor)
	_av += _frame_weight
	_av = adjust_angular_velocity_for_friction(_av, friction)
	return _av

func physics_process(delta: float) -> String:
	wheel.set_angular_velocity(calculate_angular_velocity(wheel.angular_velocity))
	wheel.step()
	return KEEP_STATE

func _on_player_entered_platform(plat : KinematicBody2D, play : KinematicBody2D) -> void:
	if plat.get_parent() == wheel:
		_weighed_platform = plat
		_player = play

func _on_player_exited_platform(plat : KinematicBody2D, play : KinematicBody2D) -> void:
	if plat == _weighed_platform:
		_weighed_platform = null
		_player = null
