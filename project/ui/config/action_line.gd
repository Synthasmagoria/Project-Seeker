extends Control
tool

class_name ActionLine

signal remap_requested(action)

export(String) var action = "" setget set_action
func set_action(val : String) -> void:
	action = val
	call_deferred("update_labels", action)

func update_labels(val : String) -> void:
	$Action.text = val.capitalize()
	if ButtonRemapper.action_exists(val):
		$Control.text = OS.get_scancode_string(ButtonRemapper.get_first_input_event_key(val).scancode)

func _on_Change_pressed() -> void:
	emit_signal("remap_requested", action)
