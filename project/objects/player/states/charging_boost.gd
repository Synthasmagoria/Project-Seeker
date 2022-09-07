extends PlayerStateAirborne

## The amount of time charged
var duration : float
## The minimum charge perform a boost
var duration_min : float = 0.5
## 
var fall_speed_max_multiplier := 0.75
##
var jump_speed_max := 100.0

func enter() -> void:
	player.modulate = Color.coral
	duration = 0.0

func physics_process(delta : float) -> String:
	
	# Prevent the player from moving horizontally
	player.velocity.x = 0.0
	
	# Apply gravity
	player.velocity.y += get_frame_gravity(delta)
	
	# Prevent the player's fall speed to exceed the limit
	player.velocity = limit_fall_velocity(player.velocity, fall_speed_max * fall_speed_max_multiplier)
	
	# Count charging time
	duration += delta
	
	# Move
	player.velocity_movement(player.velocity, false)
	
	# Handle state changes
	if player.boosted:
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
