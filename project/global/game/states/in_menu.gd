extends GameState

var pass_state = KEEP_STATE

func enter() -> void:
	pass_state = KEEP_STATE
	var _menu = NodeUtil.get_first_node_in_group("menu")
	if _menu:
		Util.connect_safe(_menu, "menu_start_game", self, "_on_menu_start_game")
	else:
		pass_state = "InGame"
	
	Util.connect_safe(LevelManager, "level_changed", self, "_on_level_changed")

func process(delta : float) -> String:
	return pass_state

func exit() -> void:
	var _menu = NodeUtil.get_first_node_in_group("menu")
	if _menu:
		Util.disconnect_safe(_menu, "menu_start_game", self, "_on_menu_start_game")

func _on_menu_start_game() -> void:
	pass_state = "InGame"

func _on_level_changed() -> void:
	pass_state = "InGame"
