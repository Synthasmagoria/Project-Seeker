extends Node

## A class that interfaces with the InputMap singleton to
## streamline the process of remapping buttons

func remap_button(action : String, new_key : int) -> void:
	var _old_event = get_first_input_event_key(action)
	
	InputMap.action_erase_event(action, _old_event)
	
	var _duplicate = get_first_duplicate_input_event_key(new_key)
	if !_duplicate.empty():
		InputMap.action_erase_event(_duplicate.action, _duplicate.event)
		InputMap.action_add_event(_duplicate.action, _old_event)
	
	InputMap.action_add_event(action, create_input_event_key(new_key))

static func create_input_event_key(key : int) -> InputEventKey:
	var _event = InputEventKey.new()
	_event.scancode = key
	return _event

static func get_first_duplicate_input_event_key(key : int) -> Dictionary:
	for a in InputMap.get_actions():
		for e in InputMap.get_action_list(a):
			if e is InputEventKey && e.scancode == key:
				return {"action" : a, "event" : e}
	return Dictionary()

static func get_first_input_event_key(action : String) -> InputEventKey:
	for e in InputMap.get_action_list(action):
		if e is InputEventKey:
			return e
	return null
