extends PlayerState

var walk_speed := 150.0
var gravity := 1000.0
var jump_strength := 400.0

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta : float) -> String:
	# Apply walking velocity
	player.velocity.x = get_walk_velocity()
	
	# Set falling speed to gravity (for floor check)
	player.velocity.y = get_frame_gravity(delta)
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = -jump_strength
	
	player.velocity_movement(player.velocity, Vector2.UP)
	
	if player.is_on_floor():
		return KEEP_STATE
	else:
		return "Airborne"
