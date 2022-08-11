extends WheelState

var velocity : Vector2
##
export(float) var gravity = 200.0

func physics_process(delta : float) -> String:
	
	velocity.y += gravity * delta
	
	wheel.position += velocity * delta
	
	wheel.step()
	
	return KEEP_STATE
