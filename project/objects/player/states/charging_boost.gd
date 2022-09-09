extends PlayerStateAirborne

## The amount of time charged
var duration : float
## The minimum charge perform a boost
var duration_min : float = 0.5
## 
var fall_speed_max_multiplier := 0.75
##
var jump_speed_max := 100.0
##
const CHARGING_PARTICLES_SCENE = preload("res://objects/player/particles/charging.tscn")
##
var particles : Particles2D
##
var walk_velocity_multiplier := 0.25

var sound : AudioStreamPlayer

func enter() -> void:
	player.modulate = Color.coral
	duration = 0.0
	particles = ParticleManager.spawn_particles(CHARGING_PARTICLES_SCENE, get_wand_facing_down(player, $"%KinematicHitshape"))

func physics_process(delta : float) -> String:
	# Align charging particles with wand
	particles.global_position = get_wand_facing_down(player, $"%KinematicHitshape")
	
	# Prevent the player from moving horizontally
	player.velocity.x = get_walk_velocity() * walk_velocity_multiplier
	
	# Apply gravity
	player.velocity.y += get_frame_gravity(delta)
	
	# Stop upwards momentum
	if !player.boosted:
		player.velocity.y = max(-100.0, player.velocity.y)
	
	# Prevent the player's fall speed to exceed the limit
	player.velocity = limit_fall_velocity(player.velocity, fall_speed_max * fall_speed_max_multiplier)
	
	# Count charging time
	duration += delta
	
	# Move
	player.velocity_movement(player.velocity, false)
	
	# Check for enemies
	var _enemy_col = player.get_enemy_collision()
	var _enemy_death = false
	
	if _enemy_col:
		if _enemy_col.normal.dot(player.up) == 1.0:
			player.velocity.y = -enemy_bounce
			_enemy_col.collider.die()
		else:
			_enemy_death = true
	
	# Handle state changes
	if player.get_killer_collision() || _enemy_death:
		return "Dead"
	
	if player.boosted || (player.is_on_floor() && !_enemy_col):
		return POP_STATE
	
	if Input.is_action_pressed("up"):
		return KEEP_STATE
	
	if duration >= duration_min:
		player.boosted = true
		return "Boost"
	else:
		return POP_STATE

func exit() -> void:
	player.modulate = Color.white
	if is_instance_valid(particles):
		particles.queue_free()
		particles = null
