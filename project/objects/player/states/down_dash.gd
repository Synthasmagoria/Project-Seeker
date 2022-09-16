extends PlayerState

var gravity = 2000.0
var max_fall_velocity = 2000.0
var enter_boost = 400.0
const LAND_PARTICLES = preload("res://objects/player/particles/land.tscn")

func enter() -> void:
	player.velocity.y += enter_boost
	player.modulate = Color.red

func physics_process(delta : float) -> String:
	player.velocity.y += gravity * delta
	
	player.velocity.y = min(max_fall_velocity, player.velocity.y)
	
	player.velocity_movement(player.velocity, false)
	
	if player.is_on_floor():
		return "Grounded"
	else:
		return KEEP_STATE

func exit() -> void:
	player.modulate = Color.white
	var _feet = player.get_node("Feet").global_position
	ParticleManager.burst_particles(LAND_PARTICLES, _feet)
	ParticleManager.burst_particles(LAND_PARTICLES, _feet).scale.x = -1.0
