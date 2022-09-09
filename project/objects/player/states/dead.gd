extends PlayerState

## Disable all the player's hitshapes
func disable_hitshapes() -> void:
	$"%KinematicHitshape".set_deferred("disabled", true)
	$"%PlatformHitshape".set_deferred("disabled", true)

func enter() -> void:
	disable_hitshapes()
	player.dead = true
	player.set_platform(null)
	player.queue_free()
