extends Node

func get_first_node_in_group(group_name : String) -> Node:
	var _group = get_tree().get_nodes_in_group(group_name)
	if _group.size() > 0:
		return _group[0]
	else:
		return null

func get_first_node_in_group_in_current_level(group_name : String) -> Node:
	var _group = get_tree().get_nodes_in_group(group_name)
	for n in _group:
		if LevelManager.is_in_current_level(n):
			return n
	return null
