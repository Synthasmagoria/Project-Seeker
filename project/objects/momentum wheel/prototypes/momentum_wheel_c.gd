extends Node2D

onready var path_follow := $Path2D/PathFollow
onready var platform := $AwarePlatform
## Momentum along the path
var momentum : float
## Direction along the path
var direction : float = 1.0

func _physics_process(delta: float) -> void:
	var _prev_pos = path_follow.position
	if momentum != 0.0:
		path_follow.offset += momentum * delta
		platform.position += path_follow.position - _prev_pos
		if is_equal_approx(path_follow.offset, $Path2D.curve.get_baked_length()) || path_follow.offset == 0.0:
			direction *= -1.0
		update()

func _draw() -> void:
	for n in get_children():
		if n is PlayerAwarePlatform:
			draw_line(path_follow.position, n.position, Color.white)


func _on_AwarePlatform_player_entered() -> void:
	momentum = 100.0 * direction


func _on_AwarePlatform_player_left() -> void:
	momentum = 0.0
