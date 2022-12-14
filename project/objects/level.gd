extends Node2D
tool

class_name Level2D

export(AudioStream) var music

const LEVEL_GROUP = "levels"

export(Vector2) var size = Vector2(1024.0, 608.0) setget set_size
func set_size(val : Vector2) -> void:
	size = val
	update()

func _init() -> void:
	add_to_group(LEVEL_GROUP)

func _ready() -> void:
	SoundManager.play_music(music)

func get_bounds() -> Rect2:
	return Rect2(position, size)

func is_point_in_bounds(p : Vector2) -> bool:
	return get_bounds().has_point(p)

func _draw() -> void:
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2.ZERO, size), Color.greenyellow, false, 3.0)
