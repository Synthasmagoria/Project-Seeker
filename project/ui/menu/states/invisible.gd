extends MenuState

onready var visuals = $"../../Visuals"

func enter() -> void:
	visuals.visible = false

func exit() -> void:
	visuals.visible = true
