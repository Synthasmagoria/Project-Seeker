extends PlayerState

var jump_strength := 400.0
var JUMP_SOUND = preload("res://objects/player/snd/jump.wav")

func enter() -> void:
	player.boosted = false

func exit() -> void:
	pass

func physics_process(delta : float) -> String:
	# Apply walking velocity
	player.velocity.x = get_walk_velocity()
	
	var _walked = get_walk_velocity() != 0.0
	
	# Set falling speed to gravity (for floor check)
	player.velocity.y = get_frame_gravity(delta)
	
	# A vairable for toggling snap off when jumping
	var _jumped = false
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = -jump_strength
		_jumped = true
		SoundManager.play_sound(JUMP_SOUND)
		# Add platform velocity to player's velocity when jumping off a platform
		if player.platform:
			player.velocity.y += min(0.0, player.platform_velocity.y)
	
	player.velocity_movement(player.velocity, !_jumped, _walked)
	
	player.refresh_airjumps()
	
	if $"%InteractableDetector".get_overlapping_areas().size() > 0 && Input.is_action_just_pressed("up"):
		return "Hiding"
	elif player.get_enemy_collision() || player.get_killer_collision():
		return "Dead"
	elif player.is_on_floor():
		return KEEP_STATE
	else:
		return "Airborne"
