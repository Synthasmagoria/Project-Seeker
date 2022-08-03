extends KinematicBody2D

var walk_speed := 150.0
var velocity := Vector2.ZERO
var gravity := 1000.0
var jump_strength := 450.0
var airjump_strength := 350.0
var airjump_number := 1
var airjump_count := 0
var jump_dampen := 0.45

static func get_walk_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")

static func dampen_jump_velocity(vel : float, damp : float) -> float:
	var _dampen = vel < 0
	return vel * damp * float(_dampen) + vel * float(!_dampen)

func move(delta : float) -> void:
	velocity.x = get_walk_input() * walk_speed
	
	if is_on_floor() || is_on_ceiling():
		velocity.y = 0.0
	
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_strength
			airjump_count = 0
		elif airjump_count < airjump_number:
			velocity.y = -airjump_strength
			airjump_count += 1
	
	if Input.is_action_just_released("jump"):
		velocity.y = dampen_jump_velocity(velocity.y, jump_dampen)
	
	move_and_slide(velocity, Vector2.UP)

func _physics_process(delta: float) -> void:
	move(delta)
