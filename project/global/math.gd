extends Object

class_name Math

static func clamp_v2(v : Vector2, mn : Vector2, mx : Vector2) -> Vector2:
	return Vector2(clamp(v.x, mn.x, mx.x), clamp(v.y, mn.y, mx.y))

static func floor_v2(v : Vector2) -> Vector2:
	return Vector2(floor(v.x), floor(v.y))
