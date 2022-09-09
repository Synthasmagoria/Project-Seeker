extends PlayerState

const SOUND = preload("res://objects/player/snd/death.wav")
const GAMEOVER = preload("res://objects/game over/game_over.tscn")

## Disable all the player's hitshapes
func disable_hitshapes() -> void:
	$"%KinematicHitshape".set_deferred("disabled", true)
	$"%PlatformHitshape".set_deferred("disabled", true)

func enter() -> void:
	SoundManager.play_sound(SOUND)
	disable_hitshapes()
	player.dead = true
	player.set_platform(null)
	player.queue_free()
	LevelManager.add_to_level(GAMEOVER.instance())
