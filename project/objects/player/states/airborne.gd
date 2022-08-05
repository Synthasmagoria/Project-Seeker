extends PlayerState

var airjump_count := 0
var airjump_number := 1
var airjump_strength := 300.0
var jump_dampen := 0.45
var platform_detector_l : RayCast2D
var platform_detector_r : RayCast2D
var platform_detector : Area2D
var previous_frame_platform : KinematicBody2D

func init(args) -> void:
	.init(args)
	platform_detector = player.get_node("PlatformDetector") as Area2D
#	platform_detector_l = player.get_node("PlatformDetectorL") as RayCast2D
#	platform_detector_r = player.get_node("PlatformDetectorR") as RayCast2D

func enter() -> void:
	airjump_count = 0

func exit() -> void:
	pass

static func dampen_jump_velocity(vel : float, damp : float) -> float:
	var _dampen = vel < 0.0
	return vel * damp * float(_dampen) + vel * float(!_dampen)

static func get_first_overlapping_platform(p_detect_area : Area2D) -> KinematicBody2D:
	if p_detect_area.get_overlapping_bodies().size() > 0:
		return p_detect_area.get_overlapping_bodies()[0] as KinematicBody2D
	else:
		return null

func process(delta : float) -> String:
	# Set walking velocity like normal
	player.velocity.x = get_walk_velocity()
	
	# Bonk!
	if player.is_on_ceiling():
		player.velocity.y = 0.0
	
	# Apply gravity
	player.velocity.y += get_frame_gravity(delta)
	
	# Jump in the air if there are airjumps left
	if Input.is_action_just_pressed("jump") && airjump_count < airjump_number:
		player.velocity.y = -airjump_strength
		airjump_count += 1
	
	# Soften the jump arc when jump is released
	if Input.is_action_just_released("jump") && player.velocity.y <= 0.0:
		player.velocity.y = dampen_jump_velocity(player.velocity.y, jump_dampen)
	
	var _platform = get_first_overlapping_platform(platform_detector)
	
	# Snap to platform if
	if previous_frame_platform && !_platform:
		var _hitbox = player.get_node("Hitbox")
		var _feet = player.position + _hitbox.position + _hitbox.shape.extents
		var _plat_hitbox = previous_frame_platform.get_node("Hitbox")
		var _plat_top = previous_frame_platform.position - _plat_hitbox.shape.extents
		if _feet.y < _plat_top.y && player.velocity.y < 0.0:
			player.distance_movement(Vector2(0.0, _plat_top.y - _feet.y))
			player.velocity.y = 0.0
	
	previous_frame_platform = _platform
	
	player.velocity_movement(player.velocity, false)
	
	# Change state
	if player.is_on_floor():
		return "Grounded"
	else:
		return KEEP_STATE
