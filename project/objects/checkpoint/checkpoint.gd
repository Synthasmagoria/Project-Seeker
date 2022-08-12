extends Area2D
tool

var player

export(Vector2) var extents setget set_extents
func set_extents(val : Vector2) -> void:
	extents = val
	update()

func _on_Checkpoint_body_entered(body: Node) -> void:
	if body == Game.player:
		Save.collect_save_write()
		player = Game.player
		$Cooldown.start()

func _on_Checkpoint_body_exited(body: Node) -> void:
	if player && body == player:
		player = null
		$Cooldown.stop()

func _on_Cooldown_timeout() -> void:
	Save.collect_save_write()

func _ready():
	if Engine.editor_hint:
		return
	
	$Hitbox.shape = RectangleShape2D.new()
	$Hitbox.shape.extents = extents

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-extents, extents * 2.0), Color.white, true)
