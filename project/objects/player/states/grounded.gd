extends PlayerState

var jump_strength := 400.0

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_process(delta : float) -> String:
	# Apply walking velocity
	player.velocity.x = get_walk_velocity()
	
	# Set falling speed to gravity (for floor check)
	player.velocity.y = get_frame_gravity(delta)
	
	# A vairable for toggling snap off when jumping
	var _jumped = false
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = -jump_strength
		_jumped = true
		# Add platform velocity to player's velocity when jumping off a platform
		if player.platform:
			player.velocity.y += min(0.0, player.platform_velocity.y)
	
	player.velocity_movement(player.velocity, !_jumped)
	
	player.refresh_airjumps()
	
	if player.get_enemy_collision() || player.get_killer_collision():
		return "Dead"
	elif player.is_on_floor():
		return KEEP_STATE
	else:
		return "Airborne"
