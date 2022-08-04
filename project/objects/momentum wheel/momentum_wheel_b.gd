extends PathFollow2D

## The platform that is being affected
var affected_platform : PlayerAwarePlatform

## The wheel's current speed along the path
var momentum := 0.0
## The maximum speed along the path
var momentum_max := 400.0
## The speed at which the wheel accelerates based on pressure put on its platforms
var momentum_acceleration := 96.0
## The speed at which the wheel slows down on its own
var momentum_friction := 4.0
## The path follow node used to 
var previous_position := Vector2.ZERO

func _ready() -> void:
#	_connect_to_child_platforms()
	previous_position = position

func _process(delta: float) -> void:
	offset += 100.0 * delta

func _on_AwarePlatform_player_entered(platform : PlayerAwarePlatform) -> void:
	affected_platform = platform

func _on_AwarePlatform_player_left(platform : PlayerAwarePlatform) -> void:
	affected_platform = null

func _connect_to_child_platforms() -> void:
	for n in $Platforms.get_children():
		n.connect("player_entered", self, "_on_AwarePlatform_player_entered", [n])
		n.connect("player_left", self, "_on_AwarePlatform_player_left", [n])
