extends KinematicBody2D

# TODO: Move state specific variables into their respective classes
var walk_speed := 150.0
var velocity := Vector2.ZERO
var gravity := 1000.0
var jump_strength := 450.0
var airjump_strength := 200.0
var airjump_number := 1
var airjump_count := 0
var jump_dampen := 0.45
var up := Vector2.UP
var on_floor : bool
var on_platform : bool
var previous_position : Vector2
var snap_distance := 4.0

## The state machine dictating player behavior
onready var state_machine := $StateMachine

static func get_walk_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")

func refresh_airjumps() -> void:
	airjump_count = 0

func velocity_movement(vel : Vector2, up : Vector2, snap : bool) -> void:
	previous_position = position
	move_and_slide_with_snap(velocity, up * -snap_distance * float(snap), up)

func distance_movement(dist : Vector2) -> void:
	previous_position = position
	move_and_collide(dist)

func _ready() -> void:
	state_machine.init([self])
