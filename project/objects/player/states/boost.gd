extends PlayerState

var boost_duration_max : float = 4.5
var next_state : String
var boost_strength := 400

var BOOST_PARTICLES_SCENE = preload("res://objects/player/particles/boost.tscn")

var particles : Particles2D

func enter() -> void:
	next_state = KEEP_STATE
	var _dur = clamp(player.state_machine.get_state_by_name("ChargingBoost").duration * 0.5, 0.0, boost_duration_max)
	get_tree().create_timer(_dur).connect("timeout", self, "_timeout")
	particles = ParticleManager.burst_particles(BOOST_PARTICLES_SCENE, get_wand_facing_down(player, $"%KinematicHitshape"), _dur)

func _timeout() -> void:
	next_state = POP_STATE

func physics_process(delta : float) -> String:
	particles.global_position = get_wand_facing_down(player, $"%KinematicHitshape")
	player.velocity.y = -boost_strength
	player.velocity.x = get_walk_velocity() * 2.0
	player.velocity_movement(player.velocity, false)
	
	if player.is_on_ceiling():
		return POP_STATE
	
	return next_state
