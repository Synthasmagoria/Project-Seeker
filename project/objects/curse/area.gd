extends KinematicBody2D

## A node that manages one curse area

class_name CurseArea2D

export(Vector2) var velocity

var shape : CollisionShape2D
var particles : Particles2D

const PARTICLES_PER_PIXEL = 0.05
const PARTICLES_SCENE = preload("res://objects/curse/curse.tscn")

func _init() -> void:
	set("motion/sync_to_physics", true)
	set_collision_layer_bit(Util.COLLISION_MASK_BIT.KILLER, true)

func _ready() -> void:
	for n in get_children():
		if !(n is CollisionShape2D):
			continue
		if !(n.shape is RectangleShape2D):
			continue
		shape = n
		particles = create_curse_particles(global_position, (n.shape as RectangleShape2D).extents)
		CurseUtil.get_curseport(self).add_child(particles)
		break
	
	if !shape || !particles:
		printerr("CurseArea2D: Cannot generate curse, no child CollisionShape2D with RectangleShape2D found")

func _physics_process(delta: float) -> void:
	position += velocity * delta
	particles.global_position = shape.global_position

static func create_curse_particles(pos : Vector2, size : Vector2) -> Particles2D:
	var _particles = PARTICLES_SCENE.instance()
	_particles.amount = size.x * size.y * PARTICLES_PER_PIXEL
	var _pmat = _particles.process_material as ParticlesMaterial
	_pmat.emission_box_extents = Vector3(size.x, size.y, 0)
	_particles.global_position = pos
	return _particles
