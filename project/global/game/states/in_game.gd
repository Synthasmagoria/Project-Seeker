extends GameState

func enter() -> void:
	if LevelManager.get_current_level():
		return
	load_saved_level()

func create_player_at_saved_position() -> void:
	var _player = load(Game.PLAYER_SCENE_PATH).instance()
	_player.global_position = Save.data.position
	LevelManager.add_to_level_persistent(_player)

func destroy_player() -> void:
	if Game.player:
		Game.player.queue_free()

func load_saved_level() -> void:
	LevelManager.change_from_path(Save.data.level_path)

func process(delta : float) -> String:
	if Input.is_action_just_pressed("reload"):
		destroy_player()
		create_player_at_saved_position()
		load_saved_level()
	
	return KEEP_STATE

func exit() -> void:
	pass
