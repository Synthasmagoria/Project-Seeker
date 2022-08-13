extends Area2D
tool

class_name Popup2D

var animation_distance = 4.0
var animation_direction = Vector2.UP
var animation_duration = 0.5
var _tween : SceneTreeTween
onready var origin = position

func _ready() -> void:
	init()
	if !Engine.editor_hint:
		connect("body_entered", self, "_on_body_entered")
		connect("body_exited", self, "_on_body_exited")
		modulate.a = 0.0

func _on_body_entered(body) -> void:
	if Game.player && body == Game.player:
		_tween = create_tween()
		_tween.tween_property(self, "position", origin + animation_direction * animation_distance, animation_duration)
		_tween.parallel()
		_tween.tween_property(self, "modulate:a", 1.0, animation_duration)

func _on_body_exited(body) -> void:
	if Game.player && body == Game.player:
		if _tween.is_running():
			_tween.kill()
		_tween = create_tween()
		_tween.tween_property(self, "position", origin, animation_duration)
		_tween.parallel()
		_tween.tween_property(self, "modulate:a", 0.0, animation_duration)

func init() -> void:
	collision_mask = 0
	collision_layer = 0
	set_collision_mask_bit(Util.COLLISION_MASK_BIT.PLAYER, true)
	monitorable = false
