extends Node2D

class_name Follow2D

## Starts following the first node in the specified group on ready
export(bool) var on_ready : bool

## The group to follow. For use with on_ready
export(String) var follow_group : String

## The _target being followed
var _target : Node2D

## Stop following the target
func stop() -> void:
	if is_instance_valid(_target):
		Util.disconnect_safe(_target, "tree_exiting", self, "_on_target_tree_exiting")
	_target = null
	set_process(false)

## Sets the first node in the given group as the target node
func follow(group : String) -> void:
	stop()
	follow_group = group
	_target = NodeUtil.get_first_valid_node_in_group(follow_group)
	if is_instance_valid(_target):
		Util.connect_safe(_target, "tree_exiting", self, "_on_target_tree_exiting")
		set_process(true)

# Follows the target's position
func _follow() -> void:
	global_position = _target.global_position

func _ready() -> void:
	if on_ready:
		follow(follow_group)
	else:
		set_process(false)

func _process(delta: float) -> void:
	_follow()

func _on_target_tree_exiting() -> void:
	stop()
