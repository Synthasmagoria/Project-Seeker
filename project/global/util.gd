extends Node

class_name Util

enum COLLISION_MASK_BIT {
	SOLID,
	PLAYER,
	PLATFORM
}

static func get_rectangle_shape_top(col_shape : CollisionShape2D) -> Vector2:
	return col_shape.position - Vector2(0.0, col_shape.shape.extents.y / 2.0)

static func get_rectangle_shape_rect(col_shape : CollisionShape2D) -> Rect2:
	return Rect2(col_shape.position - col_shape.shape.extents / 2, col_shape.shape.extents)
