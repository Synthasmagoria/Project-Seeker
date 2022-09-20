extends PlayerState

var gravity = 2000.0
var max_fall_velocity = 2000.0
var enter_boost = 400.0
var scale_x_prev = 0
var squishy = 0.8
const LAND_PARTICLES = preload("res://objects/player/particles/land.tscn")
const SOUND = preload("res://objects/player/snd/down_dash.wav")
const LAND_SOUND = preload("res://objects/player/snd/land.wav")

func enter() -> void:
	SoundManager.play_sound(SOUND)
	scale_x_prev = player.scale.x
	player.scale.x = squishy * sign(player.scale.x)
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
	SoundManager.play_sound(LAND_SOUND)
	player.modulate = Color.white
	player.scale.x = scale_x_prev
	var _feet = player.get_node("Feet").global_position
	ParticleManager.burst_particles(LAND_PARTICLES, _feet)
	ParticleManager.burst_particles(LAND_PARTICLES, _feet).scale.x = -1.0
