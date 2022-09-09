extends Node2D

export(NodePath) var follow_node

var target : Node2D

func _ready() -> void:
	target = get_node(follow_node)

func _process(delta: float) -> void:
	global_position = target.global_position
