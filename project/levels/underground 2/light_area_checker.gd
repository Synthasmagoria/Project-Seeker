extends Sprite

export(NodePath) var light_node_path
onready var light = get_node(light_node_path)

func get_world_rect() -> Rect2:
	var _size = texture.get_size() * scale
	return Rect2(global_position - _size / 2.0, _size)

func _process(delta: float) -> void:
	light.visible = get_world_rect().has_point(light.global_position)
