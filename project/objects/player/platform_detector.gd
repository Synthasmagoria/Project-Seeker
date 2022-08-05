extends Area2D

var _prev_frame : Array

func _process(delta: float) -> void:
	_prev_frame = get_overlapping_bodies().duplicate()
