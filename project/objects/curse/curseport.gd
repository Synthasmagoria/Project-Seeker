extends Viewport

class_name Curseport

const GROUP_NAME = "curseport"

func _ready() -> void:
	add_to_group(GROUP_NAME)
	transparent_bg = true
	render_target_v_flip = true
	size = Vector2(1024, 608)
	hdr = false
	usage = USAGE_2D
