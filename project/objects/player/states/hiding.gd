extends PlayerState

func enter() -> void:
	player.modulate = Color.from_hsv(0.5, 0.5, 1.0)

func physics_process(delta: float) -> String:
	if Input.is_action_pressed("up"):
		return KEEP_STATE
	else:
		return POP_STATE

func exit() -> void:
	player.modulate = Color.white;
