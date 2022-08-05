extends NodeWheel
tool

class_name NodeWheelWeight

var platform : KinematicBody2D
var player : KinematicBody2D

export(float) var weight_factor = 7.0
export(float) var friction = 5.0

func _ready() -> void:
	var _player = NodeUtil.get_first_node_in_group("player")
	if _player:
		_player.connect("entered_platform", self, "_on_player_entered_platform", [_player])
		_player.connect("exited_platform", self, "_on_player_exited_platform", [_player])

func _process(delta: float) -> void:
	var _new_av = angular_velocity
	if is_instance_valid(platform):
		var _plat_up = Vector2(
			platform.position.y,
			-platform.position.x).normalized()
		_new_av += player.up.dot(_plat_up) * weight_factor
	_new_av = max(abs(_new_av) - friction, 0.0) * sign(_new_av)
	
	if _new_av != angular_velocity:
		set_angular_velocity(_new_av)

func _on_player_entered_platform(plat : KinematicBody2D, play : KinematicBody2D) -> void:
	if plat.get_parent() == self:
		platform = plat
		player = play

func _on_player_exited_platform(plat : KinematicBody2D, play : KinematicBody2D) -> void:
	if plat == platform:
		platform = null
		player = null
