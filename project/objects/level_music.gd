extends Node

class_name LevelMusic

export(AudioStream) var music

func _ready() -> void:
	SoundManager.play_music(music)
