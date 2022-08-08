extends Camera2D

class_name FollowCamera2D

export(String) var target_group_name = "player"

export(bool) var recheck_post_exit

var target : Node2D

func _ready() -> void:
	update_target()

func _process(delta: float) -> void:
	position = target.position

func _on_target_tree_exiting() -> void:
	target = null
	if recheck_post_exit:
		get_tree().connect("idle_frame", self, "update_target", [], CONNECT_ONESHOT)
	set_process(false)

func update_target() -> void:
	target = NodeUtil.get_first_node_in_group_in_current_level(target_group_name)
	if is_instance_valid(target):
		set_process(true)
		Util.connect_safe(target, "tree_exiting", self, "_on_target_tree_exiting")
