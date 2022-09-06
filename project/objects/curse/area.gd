extends Sprite
tool

class_name CurseArea2D

const PARTICLES_PER_PIXEL = 0.05
const PARTICLES_SCENE = preload("res://objects/curse/curse.tscn")

func _ready() -> void:
	texture = preload("res://reusables/white_square.png")
	modulate = Color.from_hsv(0.35, 0.5, 1.0, 0.5)
	
	if !Engine.editor_hint:
		visible = false
		CurseUtil.get_curseport(self).add_child(create_curse_particles(global_position, texture.get_size() * scale / 2.0))

static func create_curse_particles(pos : Vector2, size : Vector2) -> Particles2D:
	var _particles = PARTICLES_SCENE.instance()
	_particles.amount = size.x * size.y * PARTICLES_PER_PIXEL
	var _pmat = _particles.process_material as ParticlesMaterial
	_pmat.emission_box_extents = Vector3(size.x, size.y, 0)
	_particles.global_position = pos
	return _particles
