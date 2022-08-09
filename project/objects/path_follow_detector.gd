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
		for n in _parent.get_children():
			if n != self && n is PathFollow2D:
				_path_follows[n.name] = n
				n.connect("tree_exiting", self, "_on_path_follow_tree_exiting", [n])

signal path_follow_passed(pf)

func _ready() -> void:
	init()
	_offset_previous = offset

# TODO: Can be optimized by ordering path follows by offset
## Checks if any of the path follows have been passed
func check_all_path_follows() -> void:
	for key in _path_follows:
		var _pf = _path_follows[key] as PathFollow2D
		if _pf.offset >= _offset_previous && _pf.offset < offset:
			emit_signal("path_follow_passed", _pf)

func _process(delta: float) -> void:
	if _offset_previous != offset:
		check_all_path_follows()
	_offset_previous = offset

func _on_path_follow_tree_exiting(pf : PathFollow2D) -> void:
	_path_follows.erase(pf.name)
