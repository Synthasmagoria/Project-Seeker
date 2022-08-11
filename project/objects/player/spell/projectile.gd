extends Area2D

var velocity : Vector2

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
	position += velocity * delta

func _on_area_entered(area : Area2D) -> void:
	pass

func _on_body_entered(body : PhysicsBody2D) -> void:
	pass
