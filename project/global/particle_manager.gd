extends Node2D

var target : Node = self setget set_target
func set_target(val : Node) -> void:
	if val == null:
		target = self
	else:
		target = val

## Instance a particles scene at a position
func spawn_particles(scn : PackedScene, pos : Vector2) -> Particles2D:
	var _inst = scn.instance() as Particles2D
	_inst.position = pos
	target.add_child(_inst)
	return _inst

## Instance a particles scene at a position and destroy after lifetime duration
func burst_particles(scn : PackedScene, pos : Vector2, dur : float = 0.0, lt : float = 0.0) -> Particles2D:
	var _inst = spawn_particles(scn, pos)
	_inst.emitting = true
	if lt > 0.0:
		_inst.lifetime = lt
	print(_inst.lifetime)
	print(_inst.lifetime - get_physics_process_delta_time() + dur)
	print(dur)
	get_tree().create_timer(_inst.lifetime - get_physics_process_delta_time() + dur).connect("timeout", self, "_burst_timeout", [_inst])
	if dur > 0.0:
		get_tree().create_timer(dur).connect("timeout", self, "_burst_duration_timeout", [_inst])
	return _inst

func _burst_timeout(part_inst : Particles2D) -> void:
	part_inst.queue_free()

func _burst_duration_timeout(part_inst : Particles2D) -> void:
	part_inst.emitting = false
