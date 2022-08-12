extends Position2D

var player_scene = load(Game.PLAYER_SCENE_PATH)

export(bool) var save_on_create : bool

func _ready() -> void:
	if !Game.player || Game.player.is_queued_for_deletion():
		var _player = player_scene.instance()
		_player.global_position = global_position
		LevelManager.add_to_level_persistent(_player)
		
		if save_on_create:
			Save.collect_data_and_save()
