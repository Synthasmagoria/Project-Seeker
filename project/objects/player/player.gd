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
## The currently stood on platform
var platform : KinematicBody2D

## The state machine dictating player behavior
onready var state_machine := $StateMachine

static func get_snap_vector(length : float, v_up : Vector2) -> Vector2:
	return v_up * -length

static func get_walk_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")

func velocity_movement(vel : Vector2, snap : bool) -> void:
	previous_position = position
	move_and_slide_with_snap(vel, get_snap_vector(snap_distance, up) * float(snap), up)

func distance_movement(dist : Vector2) -> void:
	previous_position = position
	move_and_collide(dist)

func _ready() -> void:
	state_machine.init([self])
