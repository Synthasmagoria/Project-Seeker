extends KinematicBody2D

class_name PlayerAwarePlatform

signal player_entered
signal player_left

var player : Node
var on : bool setget set_on
func set_on(val : bool) -> void:
	if on && !val:
		emit_signal("player_left")
	elif !on && val:
		emit_signal("player_entered")
	on = val

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	set_on(player.state_machine.get_current_state().name == "Grounded")

func _on_PlayerChecker_body_entered(body: Node) -> void:
	player = body
	set_process(true)

func _on_PlayerChecker_body_exited(body: Node) -> void:
	player = null
	set_on(false)
	set_process(false)
