extends CurseState

func enter() -> void:
	var _part = CurseArea2D.create_curse_particles(curse.global_position, hitbox.shape.extents)
	CurseUtil.get_curseport(self).add_child(_part)
