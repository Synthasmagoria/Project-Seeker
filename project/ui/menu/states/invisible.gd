extends MenuState

onready var visuals = $"../../Menu"

func enter() -> void:
	menu.queue_free()
