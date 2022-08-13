extends Node

const SOUND_STREAMS := 50
var sound_index := 0

const MUSIC_STREAMS := 2
var music_index := 0

func _ready() -> void:
	_init_sound_streams()

# Adds new AudioStreamPlayers to the sound streams node
func _init_sound_streams() -> void:
	for i in SOUND_STREAMS:
		$SoundStreams.add_child(AudioStreamPlayer.new())
	for i in MUSIC_STREAMS:
		$MusicStreams.add_child(AudioStreamPlayer.new())

# Increments the sound index
func _increment_sound_index() -> void:
	sound_index = (sound_index + 1) % SOUND_STREAMS

func _increment_music_index() -> void:
	music_index = (music_index + 1) % MUSIC_STREAMS

func _get_previous_music_index() -> int:
	return wrapi(music_index - 1, 0, MUSIC_STREAMS - 1)

## Plays a sound and returns the stream player that was used
func play_sound(snd : AudioStreamSample) -> AudioStreamPlayer:
	var _stream = $SoundStreams.get_child(sound_index) as AudioStreamPlayer
	_stream.stream = snd
	_stream.play()
	_increment_sound_index()
	return _stream

func play_music(mus : AudioStream) -> AudioStreamPlayer:
	if !mus:
		stop_music()
		return null
	
	var _stream = $MusicStreams.get_child(_get_previous_music_index()) as AudioStreamPlayer
	if _stream.playing && _stream.stream == mus:
		return _stream
	
	if _stream.playing:
		_stream.stop()
	
	_stream = $MusicStreams.get_child(music_index) as AudioStreamPlayer
	_stream.stream = mus
	_stream.play()
	_increment_music_index()
	return _stream

func stop_music() -> void:
	for n in $MusicStreams.get_children():
		n.stop()
