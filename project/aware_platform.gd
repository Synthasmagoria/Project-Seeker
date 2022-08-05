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

func _physics_process(delta: float) -> void:
	var _col = test_move(transform, Vector2.UP * 4.0)
	if _col:
		var _player = get_tree().get_nodes_in_group("player")[0]
		set_on(_player.state_machine.get_current_state().name == "Grounded")
	else:
		set_on(false)

func _on_PlayerChecker_body_entered(body: Node) -> void:
	player = body
	set_process(true)

func _on_PlayerChecker_body_exited(body: Node) -> void:
	player = null
	set_on(false)
	set_process(false)
