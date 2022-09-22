extends ColorRect

var action : String
var active : bool setget set_active
var consuming : bool
func set_active(val : bool) -> void:
	print("active: ", val)
	if !active && val:
		info = press_key_prompt
		$DisappearTimer.start(key_press_duration)
	elif active && !val:
		$DisappearTimer.stop()
	
	set_process_unhandled_key_input(val)
	emit_signal("toggled_active", val)
	visible = val
	consuming = val
	active = val

func prompt_remap(remap_action : String) -> void:
	action = remap_action
	set_active(true)

var info : String

signal toggled_active(active)

export(float) var key_press_duration = 3.0
export(float) var info_duration = 3.0
export(float) var success_duration = 1.5

export(String) var press_key_prompt = "Press any key"
export(String) var invalid_key_info = "Key is not mappable"
export(String) var duplicate_key_info = "Duplicate key, changed mappings"
export(String) var success_info = "Success"

func _process(delta: float) -> void:
	$PromptInfo.text = info + " (" + String(ceil($DisappearTimer.time_left)) + ")"

func _unhandled_key_input(event: InputEventKey) -> void:
	if !event.is_pressed() || !active:
		return
	
	if !consuming:
		set_active(false)
	
	$DisappearTimer.stop()
	var _result = ButtonRemapper.remap_button(action, event.scancode)
	assert(_result != ButtonRemapper.REMAP_RESULT.INVALID_ACTION)
	match _result:
		ButtonRemapper.REMAP_RESULT.UNMAPPABLE_KEY:
			info = invalid_key_info
			$DisappearTimer.start(info_duration)
		ButtonRemapper.REMAP_RESULT.SWITCH:
			info = duplicate_key_info
			$DisappearTimer.start(info_duration)
		ButtonRemapper.REMAP_RESULT.SUCCESS:
			info = success_info
			$DisappearTimer.start(success_duration)
	
	consuming = false

func _on_timeout() -> void:
	set_active(false)
