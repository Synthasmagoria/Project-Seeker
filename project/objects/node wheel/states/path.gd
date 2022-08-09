extends WheelStateWeighed

## The speed at which the wheel moves along its path
export(float, 0.1, 5.0) var path_movement_speed = 1.0
## The path to follow as the wheel rotates
export(NodePath) var path_follow_path
## Whether the wheel should follow the path follow node or not
export(bool) var follow_path
# The reference of the path to follow
onready var _path_follow : PathFollow2D = get_node(path_follow_path)
#

#
var _detaching : bool

## The action to perform when the end of a path has been reached
enum PathEndResponse{SPIN, STOP, DETACH}
export(PathEndResponse) var path_reached_beginning_response
export(PathEndResponse) var path_reached_end_response

func enter() -> void:
	if _path_follow is PathFollowDetector2D:
		_path_follow.connect("path_follow_passed", self, "_on_path_follow_passed")

func get_path_follow_direction(pf : PathFollow2D) -> Vector2:
	var _curve = pf.get_parent().curve as Curve2D
	return _curve.interpolate_baked(pf.offset + 1.0) - _curve.interpolate_baked(pf.offset)

func is_couple_direction_adjacent(src : PathFollow2D, dest : PathFollow2D) -> bool:
	return get_path_follow_direction(src).dot(get_path_follow_direction(dest)) >= 0.0

## Couples the wheel into another path
func path_couple(pcp : PathCouplingPoint2D) -> void:
	if !pcp || !is_couple_direction_adjacent(_path_follow, pcp.coupling_point):
		print("nope")
	else:
		print("yep")

func _on_path_follow_passed(pf : PathFollow2D) -> void:
	path_couple(pf)

func path_end_reached(pf : PathFollow2D, av : float) -> bool:
	return get_next_path_follow_offset(pf, av) > get_path_follow_curve_length(pf)

func path_beginning_reached(pf : PathFollow2D, av : float) -> bool:
	return get_next_path_follow_offset(pf, av) < 0.0

func get_path_follow_curve_length(pf : PathFollow2D) -> float:
	return pf.get_parent().curve.get_baked_length()

func get_next_path_follow_offset(pf : PathFollow2D, av : float) -> float:
	return pf.offset + av * get_physics_process_delta_time()

func clamp_angular_velocity_to_path_bounds(pf : PathFollow2D, av : float) -> float:
	var _next_offset = get_next_path_follow_offset(pf, av)
	var _next_offset_clamped = clamp(_next_offset, 0.0, get_path_follow_curve_length(pf))
	return _next_offset_clamped - _next_offset

func physics_process(delta : float) -> String:
	var _new_av = calculate_angular_velocity(wheel.angular_velocity)
	
	if is_instance_valid(_path_follow):
		var _beginning_reached = path_beginning_reached(_path_follow, _new_av)
		var _end_reached = path_end_reached(_path_follow, _new_av)
		
		if _beginning_reached || _end_reached:
			var _response
			if _beginning_reached:
				_response = path_reached_beginning_response
			else:
				_response = path_reached_end_response
			
			match _response:
				PathEndResponse.SPIN:
					pass # do nothing
				PathEndResponse.STOP:
					_new_av = clamp_angular_velocity_to_path_bounds(_path_follow, _new_av)
				PathEndResponse.DETACH:
					_detaching = true
		
		var _path_prev_pos = _path_follow.position
		_path_follow.offset += _new_av * path_movement_speed * delta
		
		if follow_path:
			if _detaching:
				var _direction = (_path_follow.position - _path_prev_pos).normalized()
				$"%Gravity".velocity = _direction * _new_av
				wheel.set_angular_velocity(_new_av)
				wheel.step()
				return "Gravity"
			else:
				wheel.position += _path_follow.position - _path_prev_pos
	
	wheel.set_angular_velocity(_new_av)
	wheel.step()
	
	return KEEP_STATE
