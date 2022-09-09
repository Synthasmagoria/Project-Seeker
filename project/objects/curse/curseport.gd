extends Viewport

class_name Curseport

const GROUP_NAME = "curseport"

func _ready() -> void:
	add_to_group(GROUP_NAME)
	set_up(self)
	connect_to_room_changed(self, "clear")

func _process(delta: float) -> void:
	canvas_transform = LevelManager.get_viewport().canvas_transform

func clear() -> void:
	for n in get_children():
		n.queue_free()

func on_level_changed(from, to) -> void:
	clear()

static func connect_to_room_changed(node : Node, funcname : String) -> void:
	LevelManager.connect("level_changed", node, "on_level_changed")

static func set_up(viewport : Viewport) -> void:
	viewport.transparent_bg = true
	viewport.render_target_v_flip = true
	viewport.size = Vector2(1024, 608)
	viewport.hdr = false
	viewport.usage = Viewport.USAGE_2D
