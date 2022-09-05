extends Camera2D

class_name FollowCamera2D

export(String) var target_group_name = "player"

export(bool) var recheck_post_exit

export(bool) var use_level_bounds = true

var target : Node2D

func set_limits(rect : Rect2) -> void:
	limit_left = rect.position.x
	limit_right = rect.position.x + rect.size.x
	limit_top = rect.position.y
	limit_bottom = rect.position.y + rect.size.y

func set_limits_level(level : Level2D) -> void:
	if level:
		set_limits(level.get_bounds())

func _ready() -> void:
	get_tree().connect("idle_frame", self, "update_target", [], CONNECT_ONESHOT)
	if use_level_bounds:
		set_limits_level(LevelManager.get_current_level())

func _process(delta: float) -> void:
	follow_target()

func follow_target() -> void:
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
	else:
		set_process(false)
