extends Area2D

var sound : AudioStreamPlayer
const SOUND = preload("res://objects/player/snd/save.wav")

func _process(delta: float) -> void:
	if Game.player && overlaps_body(Game.player) && Game.player.state_machine.get_current_state().name == "Grounded" && Input.is_action_just_pressed("up"):
		Save.collect_save_write()
		SoundManager.play_sound(SOUND)
