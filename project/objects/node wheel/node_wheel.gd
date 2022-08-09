extends Node2D
tool

# TODO: Find a more consistent way to rotate nodes around
# If the wheel is moving then it can easily desync with the spun nodes

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

export(float, 1.0, 320.0) var automatic_distance = 32.0 setget set_automatic_distance
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
	for n in Util.get_children_2d(self):
		n.position = n.position.normalized() * automatic_distance

func space_children_evenly() -> void:
	var _children = Util.get_children_2d(self)
	var _child_count = _children.size()
	var _child
	for i in _child_count:
		_child = _children[i]
		_child.position = Vector2.UP.rotated(deg2rad(360.0 / _child_count * i)) * _child.position.length()

func init() -> void:
	if !_initialized:
		_initialized = true
		set_angular_velocity(angular_velocity)
		set_automatic_spacing(automatic_spacing)

func rotate_children() -> void:
	for n in Util.get_children_2d(self):
		n.position = _rotation_matrix * n.position

func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
		get_tree().create_timer(1.0).connect("timeout", self, "_on_update_timeout")

func _on_update_timeout() -> void:
	update()
	get_tree().create_timer(1.0).connect("timeout", self, "_on_update_timeout")

func step() -> void:
	init()
	update()
	rotate_children()

func _physics_process(delta: float) -> void:
	step()

func _draw() -> void:
#	if Engine.editor_hint:
	for n in Util.get_children_2d(self):
		draw_line(Vector2.ZERO, n.position, Color.white)
	draw_circle(Vector2.ZERO, 4, Color.white)
