extends State

class_name CurseState

var curse : KinematicBody2D
var hitbox : CollisionShape2D

func init(cur, hbox) -> void:
	curse = cur
	hitbox = hbox
