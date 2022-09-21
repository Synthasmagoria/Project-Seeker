extends MenuState

var duration = 1.0
onready var visuals = $"../../Menu"
var next_state = "Invisible"
var pass_state = KEEP_STATE

func enter() -> void:
	pass_state = KEEP_STATE
	var _tween = create_tween()
	_tween.tween_property(visuals, "modulate:a", 0.0, duration)
	_tween.connect("finished", self, "_on_finished")

func process(delta : float) -> String:
	return pass_state

func exit() -> void:
	visuals.modulate.a = 1.0

func _on_finished() -> void:
	pass_state = next_state
