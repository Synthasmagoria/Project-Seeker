extends Area2D

var platform : KinematicBody2D

func _on_PlatformDetector_body_entered(body: Node) -> void:
	platform = body

func _on_PlatformDetector_body_exited(body: Node) -> void:
	platform = null
