extends State

class_name PlayerState

var player : KinematicBody2D

func init(body : KinematicBody2D) -> void:
	player = body

static func get_bottom(shape : CollisionShape2D) -> Vector2:
	return shape.global_position + shape.shape.extents

static func get_wand_facing_down(player : KinematicBody2D, shape : CollisionShape2D) -> Vector2:
	return Vector2(player.global_position.x, get_bottom(shape).y + 4.0)

static func recharge_boost(player : KinematicBody2D) -> void:
	player.boosted = false

func get_walk_velocity() -> float:
	return player.walk_speed * player.get_walk_input()

func get_frame_gravity(delta : float) -> float:
	return player.gravity * delta
