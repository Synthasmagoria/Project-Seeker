extends KinematicBody2D

# TODO: Move state specific variables into their respective classes
## The speed at which the player walks
var walk_speed := 150.0
## The accumulated velocity
var velocity := Vector2.ZERO
## The force of the gravity that pulls the player downwards
var gravity := 1000.0
## What direction is up
var up := Vector2.UP
## A copy of position from the previous frame of movement
var previous_position : Vector2
## Length of the vector that is opposite to up
var snap_distance := 4.0
## Platform that is currently stood on
var platform : KinematicBody2D setget set_platform
func set_platform(val : KinematicBody2D) -> void:
	if val && !platform:
		emit_signal("entered_platform", val)
	elif !val && platform:
		emit_signal("exited_platform", platform)
	platform = val

## The state machine dictating player behavior
onready var state_machine := $StateMachine

signal entered_platform(plat)
signal exited_platform(plat)

static func get_snap_vector(length : float, v_up : Vector2) -> Vector2:
	return v_up * -length

static func get_walk_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")

static func kinematic_collision_get_platform(col : KinematicCollision2D) -> KinematicBody2D:
	if col.collider is KinematicBody2D && Math.int_get_bit(col.collider.collision_layer, Util.COLLISION_MASK_BIT.PLATFORM):
		return col.collider as KinematicBody2D
	else:
		return null

func velocity_movement(vel : Vector2, snap : bool) -> void:
	previous_position = position
	move_and_slide_with_snap(vel, get_snap_vector(snap_distance, up) * float(snap), up)
	
	## Scan slide collisions for platform
	if get_slide_count() > 0:
		set_platform(kinematic_collision_get_platform(get_slide_collision(0)))
	else:
		set_platform(null)

func distance_movement(dist : Vector2) -> void:
	previous_position = position
	move_and_collide(dist)

func _ready() -> void:
	state_machine.init([self])
