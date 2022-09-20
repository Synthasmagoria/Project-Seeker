extends Area2D

var sound : AudioStreamPlayer
var save_valid_distance = 48.0
var is_current : bool setget set_is_current
func set_is_current(val) -> void:
	if val:
		modulate = COLOR_CURRENT
	else:
		modulate = COLOR_NOT
	is_current = val

const SOUND = preload("res://objects/player/snd/save.wav")
const COLOR_CURRENT = Color.green
const COLOR_NOT = Color.gray

func is_checkpoint_current() -> bool:
	return (LevelManager.get_current_level_path() == Save.data.level_path &&
			global_position.distance_to(Save.data.position) < save_valid_distance)

func can_save() -> bool:
	return (Game.player &&
			overlaps_body(Game.player) &&
			Game.player.state_machine.get_current_state().name == "Grounded" &&
			Input.is_action_just_pressed("up"))

func _ready() -> void:
	set_is_current(is_checkpoint_current())

func _process(delta: float) -> void:
	if can_save():
		Save.collect_save_write()
		SoundManager.play_sound(SOUND)
		set_is_current(true)
