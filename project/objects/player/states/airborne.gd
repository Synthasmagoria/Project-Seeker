extends PlayerState

var airjump_count := 0
var airjump_number := 1
var airjump_strength := 300.0
var jump_dampen := 0.45
var fall_speed_max := 490.0
var platform_detector : Area2D
var previous_frame_platform : KinematicBody2D

func init(args) -> void:
	.init(args)
	platform_detector = player.get_node("PlatformDetector") as Area2D

func enter() -> void:
	airjump_count = 0

func exit() -> void:
	pass

static func limit_fall_velocity(vel : Vector2, limit : float) -> Vector2:
	return Vector2(vel.x, min(vel.y, limit))

static func get_bottom(shape : CollisionShape2D) -> Vector2:
	return shape.global_position + shape.shape.extents

static func get_top(shape : CollisionShape2D) -> Vector2:
	return shape.global_position - shape.shape.extents

static func should_snap(feet : Vector2, platform_top : Vector2, velocity : Vector2) -> bool:
	return feet.y < platform_top.y && velocity.y < 0.0

static func dampen_jump_velocity(vel : float, damp : float) -> float:
	var _dampen = vel < 0.0
	return vel * damp * float(_dampen) + vel * float(!_dampen)

static func get_first_overlapping_platform(p_detect_area : Area2D) -> KinematicBody2D:
	if p_detect_area.get_overlapping_bodies().size() > 0:
		return p_detect_area.get_overlapping_bodies()[0] as KinematicBody2D
	else:
		return null

func physics_process(delta : float) -> String:
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
	
	# Snap to platform
	var _platform = get_first_overlapping_platform(platform_detector)
	
	if previous_frame_platform && !_platform:
		var _feet = get_bottom($"%KinematicHitshape")
		var _plat_top = get_top(previous_frame_platform.get_node("Hitbox"))
		
		if should_snap(_feet, _plat_top, player.velocity):
			player.distance_movement(Vector2(0.0, _plat_top.y - _feet.y))
			player.velocity.y = 0.0
	
	previous_frame_platform = _platform
	
	# Limit falling velocity
	player.velocity = limit_fall_velocity(player.velocity, fall_speed_max)
	
	# Do the regular movement
	player.velocity_movement(player.velocity, false)
	
	# Change state
	if player.is_on_floor():
		return POP_STATE
	else:
		if Input.is_action_pressed("down") && Input.is_action_pressed("jump"):
			return "DownDash"
		else:
			return KEEP_STATE
