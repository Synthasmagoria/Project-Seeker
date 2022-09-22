extends MenuState

const MUSIC = preload("res://ui/menu/seeker_loop_reverse.wav")

func enter() -> void:
	var _position = SoundManager.music_player.get_playback_position()
	SoundManager.play_music(MUSIC, _position)
	$"%Config".visible = true
	$"%Shader".set_mode(1)

func process(delta : float) -> String:
	if Input.is_action_just_pressed("ui_cancel") && !$"%Remapper".active:
		return POP_STATE
	
	return KEEP_STATE

func exit() -> void:
	$"%Config".visible = false
