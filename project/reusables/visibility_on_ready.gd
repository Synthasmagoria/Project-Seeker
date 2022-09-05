extends Node2D

export(bool) var visibility_on_ready

func _ready() -> void:
	visible = visibility_on_ready
