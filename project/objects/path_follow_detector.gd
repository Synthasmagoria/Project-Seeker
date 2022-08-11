extends PathFollow2D

class_name PathFollowDetector2D

## A dictionary keeping track of the child PathFollow2D nodes of the Path2D
var _path_follows : Dictionary
## Keeps track of previous offset value
var _offset_previous : float
## Collects and connects to all child PathFollow2D nodes to keep track
func init() -> void:
	var _parent = get_parent() as Path2D
	if _parent:
		_path_follows = collect_child_path_follows(_parent, self)

func collect_child_path_follows(node : Node, exclude : Node) -> Dictionary:
	var _pfs = {}
	for n in node.get_children():
		if n != exclude && n is PathFollow2D:
			_pfs[n.name] = n
			n.connect("tree_exiting", self, "_on_path_follow_tree_exiting", [n])
	return _pfs

signal path_follow_passed(pf)

func _ready() -> void:
	init()
	_offset_previous = offset

# TODO: Can be optimized by ordering path follows by offset
## Checks if any of the path follows have been passed
func check_all_path_follows() -> void:
	for key in _path_follows:
		var _pf = _path_follows[key] as PathFollow2D
		if offset_passed(_pf.offset, _offset_previous, offset):
			emit_signal("path_follow_passed", _pf)

func get_passed_path_follows() -> Array:
	var _pfs = []
	for key in _path_follows:
		var _pf = _path_follows[key] as PathFollow2D
		if offset_passed(_pf.offset, _offset_previous, offset):
			_pfs.push_back(_pf)
	return _pfs

func test_move(rel_off : float) -> Array:
	var _prev_offset = offset
	var _next_offset = offset + rel_off
	var _pfs = []
	for key in _path_follows:
		var _pf = _path_follows[key] as PathFollow2D
		if offset_passed(_pf.offset, _prev_offset, _next_offset):
			_pfs.push_back(_pf)
	return _pfs

func offset_passed(off : float, prev : float, curr : float) -> bool:
	return (off >= prev && off < curr) || (off <= prev && off > curr)

func _process(delta: float) -> void:
	_offset_previous = offset
#	if _offset_previous != offset:
#		check_all_path_follows()
#	_offset_previous = offset

func _on_path_follow_tree_exiting(pf : PathFollow2D) -> void:
	_path_follows.erase(pf.name)
