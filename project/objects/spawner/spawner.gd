extends Node2D
tool

export(PackedScene) var scene

export(Rect2) var area setget set_area
func set_area(val : Rect2) -> void:
	area = val
	update()

export(float, 0.1, 10.0) var interval = 1.0

export(bool) var active_on_ready = true

var active : bool setget set_active
func set_active(val : bool) -> void:
	if val == active:
		return
	
	if val:
		set_interval_timer()
	elif is_instance_valid(timer):
		unset_interval_timer()
	
	active = val

var timer : SceneTreeTimer

func _ready() -> void:
	if !Engine.editor_hint && active_on_ready:
		set_active(true)

func _draw() -> void:
	if Engine.editor_hint:
		draw_rect(area, Color.white)

func set_interval_timer() -> void:
	timer = get_tree().create_timer(interval)
	timer.connect("timeout", self, "spawn")

func unset_interval_timer() -> void:
	timer.disconnect("timeout", self, "spawn")
	timer = null

func get_random_spawn_position() -> Vector2:
	return Vector2(
			global_position.x + area.position.x + area.size.x * randf(),
			global_position.y + area.position.y + area.size.y * randf())

func spawn() -> void:
	var _instance = scene.instance()
	_instance.global_position = get_random_spawn_position()
	LevelManager.add_to_level(_instance)
	set_interval_timer()
