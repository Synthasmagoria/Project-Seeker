extends Area2D

static func set_player_killability(player : KinematicBody2D, killable : bool) -> void:
	player.set_collision_mask_bit(Util.COLLISION_MASK_BIT.KILLER, killable)

func _on_HidingSpot_player_entered(player: KinematicBody2D) -> void:
	set_player_killability(player, false)
	$Indicator.emitting = true

func _on_HidingSpot_player_exited(player: KinematicBody2D) -> void:
	set_player_killability(player, true)
	$Indicator.emitting = false
