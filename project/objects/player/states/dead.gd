extends PlayerState

# Deprecated because scene unique names exist now (cool!)
#func disable_kinematic_hitbox() -> void:
#	player.get_node("Hitbox").set_deferred("disabled", true)
#
#func disable_child_area_hitboxes() -> void:
#	for n in player.get_children():
#		if n is Area2D:
#			for nn in n.get_children():
#				if nn is CollisionShape2D:
#					nn.set_deferred("disabled", true)

## Disable all the player's hitshapes
func disable_hitshapes() -> void:
	$"%KinematicHitshape".set_deferred("disabled", true)
	$"%KillerHitshape".set_deferred("disabled", true)
	$"%PlatformHitshape".set_deferred("disabled", true)

func enter() -> void:
	disable_hitshapes()
