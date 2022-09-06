extends Node

class_name CurseUtil

static func get_curseport(from : Node):
	var _group = from.get_tree().get_nodes_in_group(Curseport.GROUP_NAME)
	if _group.size() == 0:
		var _curseport = Curseport.new()
		LevelManager.add_to_level_persistent(_curseport)
		return _curseport
	else:
		return _group[0] as Curseport
