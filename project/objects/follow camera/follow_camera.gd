extends Camera2D

class_name FollowCamera2D

export(String) var target_group_name = "player"

var target : Node2D

func _ready() -> void:
	target = NodeUtil.get_first_node_in_group(target_group_name)
	if is_instance_valid(target):
		set_process(true)
		target.connect("tree_exiting", self, "_on_target_tree_exiting")

func _process(delta: float) -> void:
	position = target.position

func _on_target_tree_exiting() -> void:
	target = null
	set_process(false)
