extends WheelState

func physics_process(delta : float) -> String:
	wheel.step()
	return KEEP_STATE
