extends Camera2D

class_name FollowCamera2D

export(String) var target_group_name = "player"

export(bool) var recheck_post_exit

export(bool) var use_level_bounds = true

var view_size = Vector2(1024, 608)

var target : Node2D

const LOOK_DURATION = 1.0
const LOOK_DISTANCE = 128.0
var _look_tween : SceneTreeTween
var _look_offset : Vector2
func look(val : Vector2) -> void:
	if is_instance_valid(_look_tween) && _look_tween.is_running():
		_look_tween.stop()
	_look_tween = create_tween()
	_look_tween.set_trans(Tween.TRANS_SINE)
	var _dur = _look_offset.distance_to(val) / LOOK_DISTANCE * LOOK_DURATION
	_look_tween.tween_property(self, "_look_offset", val, _dur)

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
	position += _look_offset
	position = clamp_to_bounds(position)
	
func clamp_to_bounds(pos : Vector2) -> Vector2:
	return Vector2(
			clamp(position.x, limit_left + view_size.x / 2.0, limit_right - view_size.x / 2.0),
			clamp(position.y, limit_top + view_size.y / 2.0, limit_bottom - view_size.y / 2.0))

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
