extends Node

const PLAYER_SCENE_PATH = "res://objects/player/player.tscn"
const FIRST_LEVEL_SCENE_PATH = "res://levels/level_intro.tscn"
var player

# TODO: Add a bunch of button checks for settings like
# fullscreen and vsync
func _ready() -> void:
	$StateMachine.init()

func _process(delta: float) -> void:
	if Input.is_action_pressed("control") && Input.is_action_just_pressed("mouse_left"):
		if Game.player:
			Game.player.global_position = $Debug.get_global_mouse_position()

func destroy_player() -> void:
	if Game.player:
		Game.player.queue_free()

func create_player_at_saved_position() -> void:
	var _player = load(Game.PLAYER_SCENE_PATH).instance()
	_player.global_position = Save.data.position
	LevelManager.add_to_level_persistent(_player)

func load_saved_level() -> void:
	Save.load()
	LevelManager.change_from_path(Save.data.level_path)

func new_game() -> void:
	Save.reset()
	Save.write()
	load_game(false)

func load_game(spawn_player : bool) -> void:
	load_saved_level()
	destroy_player()
	if spawn_player:
		create_player_at_saved_position()

func quit_game() -> void:
	pass
