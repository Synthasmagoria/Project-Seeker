extends Node2D
tool

class_name Spawner2D

export(PackedScene) var scene

export(Rect2) var area setget set_area
func set_area(val : Rect2) -> void:
	area = val
	update()

export(Dictionary) var passed_values

export(float, 0.1, 10.0) var interval = 1.0

export(bool) var active_on_ready = true

export(int) var spawn_limit = -1

export(String) var spawn_limit_group = "enemies"

export(float, 0.0, 1.0) var interval_offset = 0.99

var active : bool setget set_active
func set_active(val : bool) -> void:
	if val == active:
		return
	
	if val:
		timer = set_interval_timer(calculate_offset_interval(interval, interval_offset))
	elif is_instance_valid(timer):
		unset_interval_timer(timer)
		timer = null
	
	active = val

var timer : SceneTreeTimer

func _ready() -> void:
	modulate = Color.aquamarine
	modulate.a = 0.5
	
	if !Engine.editor_hint && active_on_ready:
		set_active(true)

func _draw() -> void:
	if Engine.editor_hint:
		draw_rect(area, Color.white)

func set_interval_timer(dur : float) -> SceneTreeTimer:
	var _timer = get_tree().create_timer(dur)
	_timer.connect("timeout", self, "spawn")
	return _timer

func unset_interval_timer(t : SceneTreeTimer) -> void:
	t.disconnect("timeout", self, "spawn")

func get_random_spawn_position() -> Vector2:
	return Vector2(
			global_position.x + area.position.x + area.size.x * randf(),
			global_position.y + area.position.y + area.size.y * randf())

static func calculate_offset_interval(inter : float, off : float) -> float:
	return inter - inter * (1.0 - Math.fract(off))

static func pass_values_to_node(node : Node, values : Dictionary) -> void:
	for key in values:
		node.set(key, values[key])

func spawn() -> void:
	if spawn_limit > 0 && get_tree().get_nodes_in_group(spawn_limit_group).size() > spawn_limit:
		return
	
	var _instance = scene.instance()
	_instance.global_position = get_random_spawn_position()
	pass_values_to_node(_instance, passed_values)
	LevelManager.add_to_level(_instance)
	timer = set_interval_timer(interval)
