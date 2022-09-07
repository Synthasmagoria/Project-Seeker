extends PlayerState

var boost_duration_max : float = 3.0
var next_state : String
var boost_strength := 400

func enter() -> void:
	next_state = KEEP_STATE
	var _dur = clamp(player.state_machine.get_state_by_name("ChargingBoost").duration, 0.0, boost_duration_max)
	get_tree().create_timer(_dur).connect("timeout", self, "_timeout")

func _timeout() -> void:
	next_state = POP_STATE

func physics_process(delta : float) -> String:
	player.velocity.y = -boost_strength
	player.velocity.x = get_walk_velocity() * 2.0
	player.velocity_movement(player.velocity, false)
	
	if player.is_on_ceiling():
		return POP_STATE
	
	return next_state
