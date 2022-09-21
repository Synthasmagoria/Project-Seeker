extends Node

## A class that takes care of saving the games configuration files
## They contain keyboard / gamepad bindings and game options

class_name Config

const FILE_NAME = "seeker_config.ini"
const BUTTONS_SECTION = "buttons"

static func save_buttons() -> void:
	var f = ConfigFile.new()
	f.load(FILE_NAME)
	_write_buttons(f)	
	f.save(FILE_NAME)

static func load_buttons() -> void:
	var f = ConfigFile.new()
	var err = f.load(FILE_NAME)
	
	if err != OK:
		return
	
	_read_buttons(f)

static func _write_buttons(f : ConfigFile) -> void:
	for a in ButtonRemapper.REMAPPABLE_KEYS:
		for e in InputMap.get_action_list(a):
			if e is InputEventKey:
				f.set_value(BUTTONS_SECTION, a, e.scancode)

static func _read_buttons(f : ConfigFile) -> void:
	for a in ButtonRemapper.REMAPPABLE_KEYS:
		var _val = f.get_value(BUTTONS_SECTION, a)
		if _val != null:
			ButtonRemapper.remap_button(a, f.get_value(BUTTONS_SECTION, a))
		else:
			printerr("Config: Tried reading a non-existing button mapping: ", a)
