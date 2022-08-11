extends Area2D

export(Vector2) var velocity
export(float, 0.1, 10.0) var life = 5.0

## The original caster
var caster : Node

signal enemy_hit(enemy)

func _ready() -> void:
	get_tree().create_timer(life).connect("timeout", self, "_on_life_timeout")

func _process(delta: float) -> void:
	position += velocity * delta

func _handle_collision(col : CollisionObject2D) -> void:
	if col.get_collision_layer_bit(Util.COLLISION_MASK_BIT.PLAYER):
		if col != caster:
			col.die()
			emit_signal("enemy_hit", col)
			queue_free()
	else:
		queue_free()

func _on_Spell_area_entered(area: Area2D) -> void:
	_handle_collision(area)

func _on_Spell_body_entered(body) -> void:
	_handle_collision(body)

func _on_life_timeout():
	queue_free()
