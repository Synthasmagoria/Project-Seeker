extends MenuState

export(AudioStreamSample) var menu_music

func enter() -> void:
	SoundManager.play_music(menu_music)
	$"%TitleMenu".visible = true
	$"%Shader".set_mode(0)

func process(delta : float) -> String:
	if Input.is_action_just_pressed("ui_accept"):
		return "Transition"
	elif Input.is_action_just_pressed("ui_cancel"):
		return "Config"
	
	return KEEP_STATE

func exit() -> void:
	SoundManager.stop_music()
	$"%TitleMenu".visible = false
