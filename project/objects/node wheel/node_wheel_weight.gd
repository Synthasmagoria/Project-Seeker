extends NodeWheel
tool

class_name NodeWheelWeight

var platform : KinematicBody2D
var player : KinematicBody2D

## The significance to momentum of the weight put onto the the wheel's platforms by the player
export(float, 0.1, 5.0) var weight_factor = 2.0
## The rate at which the wheel slows its rotation
export(float, 0.1, 5.0) var friction = 1.0

## The speed at which the wheel moves along its path
export(float, 0.1, 5.0) var path_movement_speed = 1.0
## The path to follow as the wheel rotates
export(NodePath) var path_follow_path
## Whether the wheel should follow the path follow node or not
export(bool) var follow_path
# The reference of the path to follow
onready var _path_follow : PathFollow2D = get_node_or_null(path_follow_path)

## The action to perform when the end of a path has been reached
enum PathEndResponse{SPIN, STOP, DETACH}
export(PathEndResponse) var path_reached_beginning_response
export(PathEndResponse) var path_reached_end_response

func _ready() -> void:
	if !Engine.editor_hint:
		if Game.player:
			Game.player.connect("entered_platform", self, "_on_player_entered_platform", [_player])
			Game.player.connect("exited_platform", self, "_on_player_exited_platform", [_player])

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var _new_av = angular_velocity
	if is_instance_valid(platform):
		var _plat_up = Vector2(
			platform.position.y,
			-platform.position.x).normalized()
		_new_av += player.up.dot(_plat_up) * weight_factor
	_new_av = max(abs(_new_av) - friction, 0.0) * sign(_new_av)
	
	if is_instance_valid(_path_follow):
		var _next_pf_offset = _path_follow.offset + _new_av * delta
		var _path_length = _path_follow.get_parent().curve.get_baked_length()
		var _next_pf_offset_clamped = clamp(_next_pf_offset, 0.0, _path_length)
		
		if _next_pf_offset <= 0.0:
			match path_reached_beginning_response:
				PathEndResponse.STOP:
					_new_av = (_next_pf_offset_clamped - _path_follow.offset) / delta
				PathEndResponse.DETACH:
					pass # function that detaches the node from the path follow
		elif _next_pf_offset >= _path_length:
			match path_reached_end_response:
				PathEndResponse.STOP:
					_new_av = (_next_pf_offset_clamped - _path_follow.offset) / delta
				PathEndResponse.DETACH:
					pass # function that detaches the node from the path follow
	
	if _new_av != angular_velocity:
		set_angular_velocity(_new_av)
	
	if is_instance_valid(_path_follow):
		var _path_prev_pos = _path_follow.position
		_path_follow.offset += angular_velocity * path_movement_speed * delta
		if follow_path:
			position += _path_follow.position - _path_prev_pos

func _on_player_entered_platform(plat : KinematicBody2D, play : KinematicBody2D) -> void:
	if plat.get_parent() == self:
		platform = plat
		player = play

func _on_player_exited_platform(plat : KinematicBody2D, play : KinematicBody2D) -> void:
	if plat == platform:
		platform = null
		player = null
