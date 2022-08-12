extends MenuState

#var first_level = preload("res://levels/level_1.tscn")

func process(delta : float) -> String:
	if Input.is_action_just_pressed("ui_accept"):
		LevelManager.change_from_path("res://levels/level_1.tscn")
		return "Transition"
	
	return KEEP_STATE
