extends MenuState

func process(delta : float) -> String:
	if Input.is_action_just_pressed("ui_accept"):
		return "Transition"
	
	return KEEP_STATE
