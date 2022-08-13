extends EnemyState

var duration = 0.25
onready var sprite = $"../../AnimatedSprite"
var observed = false

func enter() -> void:
	sprite.stop()
	sprite.animation = "idle"
	sprite.frame = 0
	observe()

func observe() -> void:
	observed = false
	get_tree().create_timer(duration).connect("timeout", self, "_on_timeout")

func physics_process(delta : float) -> String:
	if observed:
		if enemy.player_close:
			return "WindUp"
		elif enemy.player_far:
			return "MoveTowardsPlayer"
		else:
			observe()
	
	return KEEP_STATE

func _on_timeout() -> void:
	observed = true
