extends Area2D
tool

class_name Warp2D

export(String, FILE) var level_scene_path

export(bool) var displace_using_level_bounds = true

export(Vector2) var displacement

var _warping : bool

func _ready() -> void:
	init()
	set_process(false)
	
	if !Engine.editor_hint:
		connect("body_entered", self, "_on_body_entered")
		connect("body_exited", self, "_on_body_exited")

func _process(delta: float) -> void:
	if !_warping && !player_is_in_level():
		warp()

func _on_body_entered(body) -> void:
	if Game.player && body == Game.player:
		set_process(true)

func _on_body_exited(body) -> void:
	if Game.player && body == Game.player:
		set_process(false)

func player_is_in_level() -> bool:
	return LevelManager.get_current_level().is_point_in_bounds(Game.player.global_position)

func init() -> void:
	collision_mask = 0
	collision_layer = 0
	set_collision_mask_bit(Util.COLLISION_MASK_BIT.PLAYER, true)
	monitorable = false

func warp() -> void:
	if displace_using_level_bounds:
		var _bounds = LevelManager.get_current_level().get_bounds()
		var _pos = Game.player.global_position
		if _pos.x < _bounds.position.x:
			_pos.x += _bounds.size.x
		elif _pos.x > _bounds.end.x:
			_pos.x -= _bounds.size.x
		
		if _pos.y < _bounds.position.y:
			_pos.y += _bounds.size.y
		elif _pos.y > _bounds.end.y:
			_pos.y -= _bounds.size.y
		Game.player.global_position = _pos + displacement
	
	
	LevelManager.change_from_path(level_scene_path)
	_warping = true
