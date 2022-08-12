extends Control
tool

export(bool) var hide_snow_fg setget set_hide_snow_fg
func set_hide_snow_fg(val : bool) -> void:
	hide_snow_fg = val
	if hide_snow_fg:
		$Foreground/SnowFg.hide()
	else:
		$Foreground/SnowFg.show() 
