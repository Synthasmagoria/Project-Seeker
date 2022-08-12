extends WheelStateWeighed

## The speed at which the wheel moves along its path
export(float, 0.1, 5.0) var path_movement_speed = 0.6
## The path to follow as the wheel rotates
export(NodePath) var path_follow_path
## Whether the wheel should follow the path follow node or not
export(bool) var follow_path = true
# The reference of the path to follow
onready var _path_follow : PathFollow2D = get_node_or_null(path_follow_path)
#

#
var _detaching : bool

## The action to perform when the end of a path has been reached
enum PathEndResponse{SPIN, STOP, DETACH}
export(PathEndResponse) var path_reached_beginning_response
export(PathEndResponse) var path_reached_end_response

func get_path_follow_direction(pf : PathFollow2D) -> Vector2:
	var _curve = pf.get_parent().curve as Curve2D
	return _curve.interpolate_baked(pf.offset + 1.0) - _curve.interpolate_baked(pf.offset)

func is_couple_direction_adjacent(src : PathFollow2D, src_dir : float, dest : PathFollow2D, dest_dir : float) -> bool:
	return (get_path_follow_direction(src) * src_dir).dot(get_path_follow_direction(dest) * dest_dir) >= 0.0

func path_end_reached(pf : PathFollow2D, vel : float) -> bool:
	return get_next_path_follow_offset(pf, vel) > get_path_follow_curve_length(pf)

func path_beginning_reached(pf : PathFollow2D, vel : float) -> bool:
	return get_next_path_follow_offset(pf, vel) < 0.0

func get_path_follow_curve_length(pf : PathFollow2D) -> float:
	return pf.get_parent().curve.get_baked_length()

func get_next_path_follow_offset(pf : PathFollow2D, vel : float) -> float:
	return pf.offset + vel * get_physics_process_delta_time()

func clamp_velocity_to_path_bounds(pf : PathFollow2D, vel : float) -> float:
	var _next_offset = get_next_path_follow_offset(pf, vel)
	var _next_offset_clamped = clamp(_next_offset, 0.0, get_path_follow_curve_length(pf))
	return _next_offset_clamped - _next_offset

func physics_process(delta : float) -> String:
	var _new_av = calculate_angular_velocity(wheel.angular_velocity)
	var _vel = _new_av * path_movement_speed
	
	if is_instance_valid(_path_follow):
		# Check if we're going to move past a coupling point in the right direction
		var _coupled = false
		
		var _passed_pfs = _path_follow.test_move(_vel * delta)
		if _passed_pfs.size() > 0:
			var _direction = sign(_new_av)
			for n in _passed_pfs:
				var _pcp = n as PathCouplingPoint2D
				if _pcp && is_couple_direction_adjacent(_path_follow, _direction, _pcp.coupling_point, _pcp.coupling_direction):
					# Calculate total travel distance
					
					var _remainder = abs(_vel * delta)
					# Figure out the distance between the current path follow offset and coupling path follow offset
					var _move = _pcp.coupling_point.global_position - _path_follow.global_position
					#
					_remainder -= _move.length()
					# Move the wheel to the coupling point
					wheel.position += _move
					# Go to coupling position
					_path_follow.offset = _pcp.coupling_point.offset
					# Make sure the wheel's follow node is at the right position
					_pcp.node_wheel_follow.offset = _pcp.coupling_point.offset
					# Change path follow node to follow
					_path_follow = _pcp.node_wheel_follow
					# 
					var _prev_pf_pos = _path_follow.position
					_path_follow.offset += _remainder * _direction
					#
					wheel.position += _path_follow.position - _prev_pf_pos
					# Yeah we coupled (velocity has been handled)
					_coupled = true
					# Break the loop
					break
		
		
		var _beginning_reached = path_beginning_reached(_path_follow, _vel)
		var _end_reached = path_end_reached(_path_follow, _vel)
		
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
					_new_av = clamp_velocity_to_path_bounds(_path_follow, _vel)
				PathEndResponse.DETACH:
					_detaching = true
		
		if !_coupled:
			var _path_prev_pos = _path_follow.position
			_path_follow.offset += _vel * delta
			
			if follow_path:
				if _detaching:
					var _direction = (_path_follow.position - _path_prev_pos).normalized()
					var _velocity = _direction * abs(_vel)
					$"%Gravity".velocity = _velocity
					wheel.position += _velocity * delta
					wheel.set_angular_velocity(_new_av)
					wheel.step()
					return "Gravity"
				else:
					wheel.position += _path_follow.position - _path_prev_pos
	
	wheel.set_angular_velocity(_new_av)
	wheel.step()
	
	return KEEP_STATE
