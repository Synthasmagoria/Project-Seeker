extends CanvasLayer

signal menu_start_game

func _ready() -> void:
	$StateMachine.init([self])


func _on_StateMachine_state_changed(from, to) -> void:
	if to.name == "Transition":
		emit_signal("menu_start_game")
