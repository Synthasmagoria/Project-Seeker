extends PlayerState

var gravity = 2000.0
var max_fall_velocity = 2000.0
var enter_boost = 400.0

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
		if Input.is_action_pressed("down") && Input.is_action_pressed("jump"):
			return KEEP_STATE
		else:
			return POP_STATE

func exit() -> void:
	player.modulate = Color.white
