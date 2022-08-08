extends Node2D
tool

class_name NodeWheel

var _rotation_matrix : Transform2D
var _initialized : bool

export(float) var angular_velocity = 100.0 setget set_angular_velocity
func set_angular_velocity(val : float) -> void:
	angular_velocity = val
	_rotation_matrix = Transform2D(deg2rad(angular_velocity) * get_physics_process_delta_time(), Vector2.ZERO)

export(bool) var automatic_spacing setget set_automatic_spacing
func set_automatic_spacing(val : bool) -> void:
	automatic_spacing = val
	if automatic_spacing:
		space_children_evenly()

export(float) var automatic_distance setget set_automatic_distance
func set_automatic_distance(val : float) -> void:
	automatic_distance = max(1.0, val)
	if automatic_distancing:
		distance_children_evenly()

export(bool) var automatic_distancing setget set_automatic_distancing
func set_automatic_distancing(val : bool) -> void:
	automatic_distancing = val
	if automatic_distancing:
		distance_children_evenly()

func distance_children_evenly() -> void:
	for n in get_children():
		n.position = n.position.normalized() * automatic_distance

func space_children_evenly() -> void:
	var _children = get_child_count()
	var _child
	for i in _children:
		_child = get_child(i)
		assert((_child as Node2D), "Child was not of type Node2D")
		_child.position = Vector2.UP.rotated(deg2rad(360.0 / _children * i)) * _child.position.length()

func init() -> void:
	set_angular_velocity(angular_velocity)
	set_automatic_spacing(automatic_spacing)

func _ready() -> void:
	init()
	if Engine.editor_hint:
		set_physics_process(false)
		set_process(false)
		get_tree().create_timer(1.0).connect("timeout", self, "_on_update_timeout")

func _on_update_timeout() -> void:
	update()
	get_tree().create_timer(1.0).connect("timeout", self, "_on_update_timeout")

func _physics_process(delta: float) -> void:
	if !_initialized:
		init()
		_initialized = true
	update()
	for n in get_children():
		n.position = _rotation_matrix * n.position

func _draw() -> void:
#	if Engine.editor_hint:
	for n in get_children():
		draw_line(Vector2.ZERO, n.position, Color.white)
	draw_circle(Vector2.ZERO, 4, Color.white)
