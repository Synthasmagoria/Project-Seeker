extends GameState

func process(delta : float) -> String:
	if Input.is_action_just_pressed("reload"):
		Game.load_game(true)
	return KEEP_STATE

func exit() -> void:
	pass
