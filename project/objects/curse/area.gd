extends KinematicBody2D
tool

## A node that manages one curse area

class_name CurseArea2D

export(Vector2) var extents = Vector2(32.0, 32.0) setget set_extents
func set_extents(val : Vector2) -> void:
	extents = val
	update()

var shape : CollisionShape2D
var particles : Particles2D
var timeout_duration := 0.0
var default_state := "Static"

const PARTICLES_PER_PIXEL = 0.05
const PARTICLES_SCENE = preload("res://objects/curse/curse.tscn")

func _init() -> void:
	if Engine.editor_hint:
		modulate = Color.aquamarine
		modulate.a = 0.5
		return
	
	set("motion/sync_to_physics", true)
	set_collision_layer_bit(Util.COLLISION_MASK_BIT.KILLER, true)

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	$Area.shape = RectangleShape2D.new()
	$Area.shape.extents = extents
	shape = $Area
	$StateMachine.default_state = default_state
	$StateMachine.init([self, $Area])
	if timeout_duration > 0.0:
		get_tree().create_timer(timeout_duration).connect("timeout", self, "_timeout")

func _draw() -> void:
	if Engine.editor_hint:
		draw_rect(Rect2(-extents, extents * 2.0), Color.white)

func _timeout() -> void:
	queue_free()

#func set_up_curse_particles() -> void:
#	shape = get_curse_area(self)
#	particles = create_curse_particles(global_position, shape.shape.extents)
#	CurseUtil.get_curseport(self).add_child(particles)
#
#	if !shape || !particles:
#		printerr("CurseArea2D: Cannot generate curse, no child CollisionShape2D with RectangleShape2D found")

# Returns the a CollisionShape2D node fit for representing the curse's area
static func get_curse_area(from : Node) -> CollisionShape2D:
	for n in from.get_children():
		if !(n is CollisionShape2D):
			continue
		if !(n.shape is RectangleShape2D):
			continue
		return n
	return null

static func create_curse_particles(pos : Vector2, size : Vector2) -> Particles2D:
	var _particles = PARTICLES_SCENE.instance()
	_particles.amount = size.x * size.y * PARTICLES_PER_PIXEL
	var _pmat = _particles.process_material as ParticlesMaterial
	_pmat.emission_box_extents = Vector3(size.x, size.y, 1.0)
	_particles.global_position = pos
	return _particles

static func calculate_particle_number(extents : Vector2) -> float:
	return extents.x * extents.y * PARTICLES_PER_PIXEL
