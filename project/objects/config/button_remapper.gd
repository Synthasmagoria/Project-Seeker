extends Node

## A class that interfaces with the InputMap singleton to
## streamline the process of remapping buttons

enum REMAP_RESULT {INVALID_ACTION, UNMAPPABLE_KEY, SWITCH, SUCCESS}

const REMAPPABLE_KEYS = ["left", "right", "up", "down", "jump", "reload"]

class_name ButtonRemapper

## Checks if the passed scancode is occupied by an unremappable option
static func is_key_mappable(key : int) -> bool:
	return !get_unmappable_keys().has(key)

## Remaps an action to use the desired key if possible
static func remap_button(action : String, new_key : int) -> int:
	if !REMAPPABLE_KEYS.has(action):
		printerr("ButtonRemapper: Action '", action, "' does not exist in the input map")
		return REMAP_RESULT.INVALID_ACTION
	
	if !is_key_mappable(new_key):
#		print("ButtonRemapper: Key ", new_key, " is not mappable")
		return REMAP_RESULT.UNMAPPABLE_KEY
	
	var _result = REMAP_RESULT.SUCCESS
	var _old_event = get_first_input_event_key(action)
	
	InputMap.action_erase_event(action, _old_event)
	
	var _duplicate = get_first_duplicate_input_event_key(new_key)
	if !_duplicate.empty():
		InputMap.action_erase_event(_duplicate.action, _duplicate.event)
		InputMap.action_add_event(_duplicate.action, _old_event)
		_result = REMAP_RESULT.SWITCH
	
	InputMap.action_add_event(action, create_input_event_key(new_key))
	return _result

## Creates a new InputEventKey to be passed to InputMap
static func create_input_event_key(key : int) -> InputEventKey:
	var _event = InputEventKey.new()
	_event.scancode = key
	return _event

## Returns an array of keys that are not to be mapped to
static func get_unmappable_keys() -> Array:
	var _keys = []
	for a in InputMap.get_actions():
		if REMAPPABLE_KEYS.has(a):
			continue
		var e = get_first_input_event_key(a)
		if e:
			_keys.push_back(e)
	return _keys

## Checks if an input action exists
static func action_exists(action : String) -> bool:
	return InputMap.get_actions().has(action)

## Scans all remappable actions for an InputEventKey with the passed scancode
## Returns a dictionary with the first duplicate action and event pair it finds
static func get_first_duplicate_input_event_key(key : int) -> Dictionary:
	for a in REMAPPABLE_KEYS:
		for e in InputMap.get_action_list(a):
			if e is InputEventKey && e.scancode == key:
				return {"action" : a, "event" : e}
	return Dictionary()

## Finds the first InputEventKey in the passed action in InputMap
static func get_first_input_event_key(action : String) -> InputEventKey:
	for e in InputMap.get_action_list(action):
		if e is InputEventKey:
			return e
	return null
