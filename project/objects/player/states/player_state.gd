extends State

class_name PlayerState

var player : KinematicBody2D

func init(body : KinematicBody2D) -> void:
	player = body

static func recharge_boost(player : KinematicBody2D) -> void:
	player.boosted = false

func get_walk_velocity() -> float:
	return player.walk_speed * player.get_walk_input()

func get_frame_gravity(delta : float) -> float:
	return player.gravity * delta
