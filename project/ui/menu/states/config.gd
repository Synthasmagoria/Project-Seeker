extends MenuState

const MUSIC = preload("res://ui/menu/seeker_loop_reverse.wav")
export(NodePath) var config_path
var config : Control

func enter() -> void:
	var _position = SoundManager.music_player.get_playback_position()
	SoundManager.play_music(MUSIC, _position)
	config = get_node(config_path)
	config.visible = true

func exit() -> void:
	config.visible = false
