extends Path2D
tool

class_name NodeWheelPath2D

const DRAW_SIZE = 8.0
## What do to at the path beginning and end
enum PathEndResponse{SPIN, STOP, DETACH}
## Beginning
export(PathEndResponse) var path_reached_beginning_response setget set_path_reached_beginning_response
func set_path_reached_beginning_response(val) -> void:
	path_reached_beginning_response = val
	update()

## End
export(PathEndResponse) var path_reached_end_response setget set_path_reached_end_response
func set_path_reached_end_response(val) -> void:
	path_reached_end_response = val
	update()

func draw_ending(pos : Vector2, end : int) -> void:
	match end:
		PathEndResponse.SPIN:
			draw_circle(pos, DRAW_SIZE, Color.white)
		PathEndResponse.STOP:
			draw_rect(Rect2(pos - Vector2.ONE * DRAW_SIZE / 2.0, Vector2.ONE * DRAW_SIZE), Color.white)
		PathEndResponse.DETACH:
			pass

func _draw() -> void:
	draw_ending(curve.interpolate_baked(0), path_reached_beginning_response)
	draw_ending(curve.interpolate_baked(curve.get_baked_length()), path_reached_end_response)
