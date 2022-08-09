extends NodeWheel
tool

export(String) var first_state = "FollowPath"

func _ready() -> void:
	if !Engine.editor_hint:
		$StateMachine.default_state = first_state
		$StateMachine.init([self])
	set_physics_process(false)
