extends GameState

const MENU_SCENE = preload("res://ui/menu/menu.tscn")

func process(delta : float) -> String:
	if Input.is_action_just_pressed("reload"):
		Game.load_game(true)
	
	if Input.is_action_pressed("control") && Input.is_action_just_pressed("mouse_left") && Game.player:
		Game.player.global_position = $Debug.get_global_mouse_position()
	
	if Input.is_action_just_pressed("menu") && !NodeUtil.get_first_node_in_group("menu"):
		return_to_menu()
		return POP_STATE
	
	return KEEP_STATE

func return_to_menu() -> void:
	LevelManager.clear()
	get_viewport().add_child(MENU_SCENE.instance())

func exit() -> void:
	pass
