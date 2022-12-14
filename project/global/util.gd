extends Node

class_name Util

enum COLLISION_MASK_BIT {
	SOLID,
	PLAYER,
	PLATFORM,
	KILLER,
	PROJECTILE
}

static func get_rectangle_shape_top(col_shape : CollisionShape2D) -> Vector2:
	return col_shape.position - Vector2(0.0, col_shape.shape.extents.y / 2.0)

static func get_rectangle_shape_rect(col_shape : CollisionShape2D) -> Rect2:
	return Rect2(col_shape.position - col_shape.shape.extents / 2, col_shape.shape.extents)

## Call a function on all direct children of the passed node
static func call_on_children(node : Node, f : FuncRef, args : Array = []) -> void:
	for n in node.get_children():
		n.callv(f, args)

## Checks if the signal is connected, if it isn't then connects
static func connect_safe(source : Object, signal_name : String, target : Object, method : String, binds := [], flags := 0) -> bool:
	if source.is_connected(signal_name, target, method):
		return false
	else:
		source.connect(signal_name, target, method, binds, flags)
		return true

static func disconnect_safe(source : Object, signal_name : String, target : Object, method : String) -> bool:
	if !source.is_connected(signal_name, target, method):
		return false
	else:
		source.disconnect(signal_name, target, method)
		return true

static func get_children_2d(node : Node) -> Array:
	var _children = node.get_children()
	var _children_2d = []
	for n in _children:
		if n as Node2D:
			_children_2d.push_back(n)
	return _children_2d

static func tilemap_get_used_rect_by_id(tilemap : TileMap, id : int) -> Rect2:
	var _cells = tilemap.get_used_cells_by_id(id)
	
	var _top = _cells[0].y
	var _bottom = _cells[0].y
	var _right = _cells[0].x
	var _left = _cells[0].x
	
	for v in tilemap.get_used_cells_by_id(id):
		_left = min(_left, v.x)
		_top = min(_top, v.y)
		_right = max(_right, v.x)
		_bottom = max(_bottom, v.y)
	
	return Rect2(_left, _top, _right - _left, _bottom - _top)
