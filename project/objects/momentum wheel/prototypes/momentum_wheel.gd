extends Node2D

## The platform that is being affected
var affected_platform : PlayerAwarePlatform

## The wheel's current speed along the path
var momentum := 0.0
## The maximum speed along the path
var momentum_max := 400.0
## The speed at which the wheel accelerates based on pressure put on its platforms
var momentum_acceleration := 96.0
## The speed at which the wheel slows down on its own
var momentum_friction := 4.0
## The path follow node used to calculate movement
onready var path_follow := $Path/PathFollow
##
var previous_position := Vector2.ZERO

func _ready() -> void:
	_connect_to_child_platforms()
	previous_position = path_follow.position

func _physics_process(delta: float) -> void:
	if is_instance_valid(affected_platform):
		var _platform_down = Vector2(
			affected_platform.position.y,
			-affected_platform.position.x).normalized()
		var _effect = _platform_down.dot(Vector2.UP)
		momentum += _effect * momentum_acceleration * delta
	
	momentum = (abs(momentum) - momentum_friction * delta) * sign(momentum)
	previous_position = path_follow.position
	path_follow.offset += momentum * delta
	
	var _collision : KinematicCollision2D
	for n in $Platforms.get_children():
		_collision = n.move_and_collide(path_follow.position - previous_position)
		if _collision: # move other node out of the way
			n.move_and_collide(_collision.remainder)

func _on_AwarePlatform_player_entered(platform : PlayerAwarePlatform) -> void:
	affected_platform = platform

func _on_AwarePlatform_player_left(platform : PlayerAwarePlatform) -> void:
	affected_platform = null

func _connect_to_child_platforms() -> void:
	for n in $Platforms.get_children():
		n.connect("player_entered", self, "_on_AwarePlatform_player_entered", [n])
		n.connect("player_left", self, "_on_AwarePlatform_player_left", [n])
