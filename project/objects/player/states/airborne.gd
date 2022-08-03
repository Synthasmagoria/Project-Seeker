extends PlayerState

var airjump_count := 0
var airjump_number := 1
var airjump_strength := 300.0
var jump_dampen := 0.45
var platform_detector_l : RayCast2D
var platform_detector_r : RayCast2D

func init(args) -> void:
	.init(args)
	platform_detector_l = player.get_node("PlatformDetectorL") as RayCast2D
	platform_detector_r = player.get_node("PlatformDetectorR") as RayCast2D

func enter() -> void:
	airjump_count = 0

func exit() -> void:
	pass

func process(delta : float) -> String:
	# Set walking velocity like normal
	player.velocity.x = get_walk_velocity()
	
	# Apply gravity
	player.velocity.y += get_frame_gravity(delta)
	
	# Jump in the air if there are airjumps left
	if Input.is_action_just_pressed("jump") && airjump_count < airjump_number:
		player.velocity.y = -airjump_strength
		airjump_count += 1
	
	# Soften the jump arc when jump is released
	if Input.is_action_just_released("jump") && player.velocity.y <= 0.0:
		player.velocity.y *= jump_dampen
	
	# Bonk!
	if player.is_on_ceiling():
		player.velocity.y = 0.0
	
	# Collect useful information about platform collisions
	var _plat = null
	var _plat_dist = platform_detector_l.cast_to.y
	var _plat_top := Vector2.ZERO
	var _plat_hitbox : CollisionShape2D
	
	if platform_detector_l.get_collider():
		_plat = platform_detector_l.get_collider()
		_plat_hitbox = _plat.get_node("Hitbox")
		_plat_top = _plat.position + _plat_hitbox.position - _plat_hitbox.shape.extents
		_plat_dist = _plat_top.distance_to(platform_detector_l.global_position)
	
	if platform_detector_r.get_collider():
		var _plat_r = platform_detector_r.get_collider()
		var _plat_hitbox_r = _plat_r.get_node("Hitbox")
		var _plat_top_r = _plat_r.position + _plat_hitbox_r.position - _plat_hitbox_r.shape.extents
		var _plat_dist_r = _plat_top_r.distance_to(platform_detector_r.global_position)
		if _plat_dist_r < _plat_dist:
			_plat = _plat_r
			_plat_hitbox = _plat_hitbox_r
			_plat_top = _plat_top_r
			_plat_dist = _plat_dist_r
	
	# Snap
	if _plat:
		var _hitbox = player.get_node("Hitbox")
		var _feet = player.position + _hitbox.position + _hitbox.shape.extents
		var _feet_prev = player.previous_position + _hitbox.position + _hitbox.shape.extents
		
		if _plat_top.y < _feet_prev.y && _plat_top.y >= _feet.y:
			print(_plat_top, _feet, _feet_prev)
			player.distance_movement(Vector2(0.0, _plat_top.y - _feet.y))
			player.velocity.y = 0.0

	player.velocity_movement(player.velocity, Vector2.UP)
	
	# Change state
	if player.is_on_floor():
		return "Grounded"
	else:
		return KEEP_STATE
