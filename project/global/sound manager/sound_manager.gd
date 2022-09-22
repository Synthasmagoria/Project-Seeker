extends Node

const SOUND_STREAMS := 50
var sound_index := 0

onready var music_player = $MusicPlayer 

func _ready() -> void:
	_init_sound_streams()

# Adds new AudioStreamPlayers to the sound streams node
func _init_sound_streams() -> void:
	for i in SOUND_STREAMS:
		var _stream = AudioStreamPlayer.new()
		_stream.bus = "Effect"
		$SoundStreams.add_child(_stream)

# Increments the sound index
func _increment_sound_index() -> void:
	sound_index = (sound_index + 1) % SOUND_STREAMS

## Plays a sound and returns the stream player that was used
func play_sound(snd : AudioStreamSample) -> AudioStreamPlayer:
	var _stream = $SoundStreams.get_child(sound_index) as AudioStreamPlayer
	_stream.stream = snd
	_stream.play()
	_increment_sound_index()
	return _stream

func play_music(mus : AudioStream, from : float = 0.0) -> AudioStreamPlayer:
	# Stop if passed null
	if !mus:
		stop_music()
		return null
	
	# Prevent the same music from restarting if attempted to play twice
	if music_player.playing && music_player.stream.resource_path == mus.resource_path:
		return music_player
	
	if music_player.playing:
		music_player.stop()
	
	music_player.stream = mus
	music_player.play(from)
	return music_player

func stop_music() -> void:
	music_player.stop()
