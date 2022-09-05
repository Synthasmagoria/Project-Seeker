extends Node2D

export(float) var locked_rotation
export(bool) var physics

func _ready() -> void:
	if physics:
		get_tree().connect("physics_frame", self, "lock_rotation")
	else:
		get_tree().connect("idle_frame", self, "lock_rotation")

func lock_rotation() -> void:
	global_rotation = locked_rotation
