extends CanvasLayer

func _ready() -> void:
	$StateMachine.init([self])
