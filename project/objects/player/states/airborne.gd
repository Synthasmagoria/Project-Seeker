extends PlayerState

class_name PlayerStateAirborne

var airjump_strength := 300.0
var jump_dampen := 0.45
var fall_speed_max := 490.0
var platform_detector : Area2D
var previous_frame_platform : KinematicBody2D
var enemy_bounce := 450.0
var afterimage_threshold := 500.0
var afterimage_particles : Particles2D
var afterimage_stop_threshold := 100.0
const AIRJUMP_PARTICLES = preload("res://objects/player/particles/airjump.tscn")
const AIRJUMP_SOUND = preload("res://objects/player/snd/airjump.wav")
const MOMENTUM_SOUND = preload("res://objects/player/snd/momentum.wav")

func init(args) -> void:
	.init(args)
	platform_detector = player.get_node("PlatformDetector") as Area2D
	afterimage_particles = player.get_node("AfterimageParticles") as Particles2D

func exit() -> void:
	afterimage_particles.emitting = false

static func limit_fall_velocity(vel : Vector2, limit : float) -> Vector2:
	return Vector2(vel.x, min(vel.y, limit))

static func get_top(shape : CollisionShape2D) -> Vector2:
	return shape.global_position - shape.shape.extents

static func should_snap(feet : Vector2, platform_top : Vector2, velocity : Vector2) -> bool:
	return feet.y < platform_top.y && velocity.y < 0.0

static func dampen_jump_velocity(vel : float, damp : float) -> float:
	var _dampen = vel < 0.0
	return vel * damp * float(_dampen) + vel * float(!_dampen)

static func should_emit_momentum_particles(emitting : bool, vel : float, thresh : float, stop_thresh : float) -> bool:
	if emitting:
		return vel <= -stop_thresh
	else:
		return vel <= -thresh

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
	
	# Activate particles if exceeding jumping speed
	var emit = should_emit_momentum_particles(
			afterimage_particles.emitting,
			player.velocity.y,
			afterimage_threshold,
			afterimage_stop_threshold)
	
	if emit && !afterimage_particles.emitting:
		SoundManager.play_sound(MOMENTUM_SOUND)
	
	afterimage_particles.emitting = emit
	
	# Jump in the air if there are airjumps left
	if Input.is_action_just_pressed("jump") && player.can_airjump():
		player.velocity.y = -airjump_strength
		player.count_airjump()
		SoundManager.play_sound(AIRJUMP_SOUND)
		ParticleManager.burst_particles(
				AIRJUMP_PARTICLES,
				Vector2(player.global_position.x, get_bottom($"%KinematicHitshape").y),
				2.0)
	
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
	
	var _enemy_col = player.get_enemy_collision()
	var _enemy_death = false
	
	if _enemy_col:
		if _enemy_col.normal.dot(player.up) == 1.0:
			player.velocity.y = -enemy_bounce
			_enemy_col.collider.die()
		else:
			_enemy_death = true
	
	# Change state
	if player.get_killer_collision() || _enemy_death:
		return "Dead"
	
	if player.is_on_floor() && !_enemy_col:
		return POP_STATE
	
	if Input.is_action_pressed("up") && !player.boosted:
		return "ChargingBoost"
	
	if Input.is_action_pressed("jump") && Input.is_action_pressed("down"):
		return "DownDash"
	
	return KEEP_STATE
