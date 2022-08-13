extends KinematicBody2D

enum PlayerDetectionShapes{CLOSE, FAR}

var player : Node2D
var player_close : bool
var player_far : bool

var far_radius := -1.0 setget set_far_radius
func set_far_radius(val : float) -> void:
	far_radius = val
	if far_radius > 0.0:
		$PlayerDetector/Far.shape.radius = far_radius

func _ready() -> void:
	$StateMachine.init([self])

func die() -> void:
	queue_free()

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body


func _on_PlayerDetector_body_exited(body: Node) -> void:
	if body == player:
		player = null


func _on_PlayerDetector_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		player = body
		
		match local_shape_index:
			PlayerDetectionShapes.CLOSE:
				player_close = true
			PlayerDetectionShapes.FAR:
				player_far = true
				pass

func _on_PlayerDetector_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if player && body == player:
		match local_shape_index:
			PlayerDetectionShapes.CLOSE:
				player_close = false
			PlayerDetectionShapes.FAR:
				player_far = false
				player = null
