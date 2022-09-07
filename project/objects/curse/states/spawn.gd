extends CurseState

var next_state := KEEP_STATE
var curse_height := 40.0
var duration := 1.5

var _tween : SceneTreeTween
var particles : Particles2D
var material : ParticlesMaterial

func _reset() -> void:
	next_state = KEEP_STATE

func enter() -> void:
	_reset()
	
	# Create particles node
	particles = CurseArea2D.create_curse_particles(curse.global_position, hitbox.shape.extents)
	particles.preprocess = 0.0
	material = particles.process_material
	CurseUtil.get_curseport(self).add_child(particles)
	
	# Pass particles node to curse
	curse.particles = particles
	
	# Set up emission box and variables
	var _ebox = Vector3(material.emission_box_extents.x, curse_height, material.emission_box_extents.z)
	material.emission_box_extents.y = 1.0
	hitbox.shape.extents.y = 1.0
	
	# Tween area and
	_tween = create_tween()
	_tween.tween_property(material, "emission_box_extents", _ebox, duration)
	_tween.parallel()
	_tween.tween_property(hitbox.shape, "extents", Vector2(_ebox.x, _ebox.y), duration)
	_tween.connect("finished", self, "_finished")

func _finished() -> void:
	next_state = "Flow"

func physics_process(delta : float) -> String:
	return next_state

func exit() -> void:
	if is_instance_valid(_tween):
		_tween.stop()
	_tween = null
