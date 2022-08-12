extends Node

const PLAYER_SCENE_PATH = "res://objects/player/player.tscn"
const FIRST_LEVEL_SCENE_PATH = "res://levels/level_intro.tscn"
var player

# TODO: Add a bunch of button checks for settings like
# fullscreen and vsync
func _ready() -> void:
	$StateMachine.init([self])

func _process(delta: float) -> void:
	if Input.is_action_pressed("control") && Input.is_action_just_pressed("mouse_left"):
		if Game.player:
			Game.player.global_position = $Debug.get_global_mouse_position()

