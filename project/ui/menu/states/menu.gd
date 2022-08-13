extends MenuState

export(AudioStreamSample) var menu_music

func enter() -> void:
	SoundManager.play_music(menu_music)

func process(delta : float) -> String:
	if Input.is_action_just_pressed("ui_accept"):
		return "Transition"
	
	return KEEP_STATE

func exit() -> void:
	SoundManager.stop_music()
