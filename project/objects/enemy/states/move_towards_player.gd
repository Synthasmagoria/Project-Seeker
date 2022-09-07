extends EnemyState

var player
onready var agent = $"../../NavigationAgent2D"
onready var sprite = $"../../AnimatedSprite"
export(float) var speed = 150.0
export(float) var threshold = 4.0
var timer : SceneTreeTimer
var path : Array

var refresh_interval = 0.95

func connect_to_agent() -> void:
	agent.connect("velocity_computed", self, "_on_velocity_computed")

func disconnect_from_agent() -> void:
	agent.disconnect("velocity_computed", self, "_on_velocity_computed")

func enter() -> void:
	connect_to_agent()
	sprite.play("move")

func set_path_refresh_timer() -> void:
	timer = get_tree().create_timer(refresh_interval)
	timer.connect("timeout", self, "_on_refresh_timer_timeout")

func unset_path_fresh_timer() -> void:
	if is_instance_valid(timer):
		timer.disconnect("timeout", self, "_on_refresh_timer_timeout")
		timer = null

func _on_refresh_timer_timeout() -> void:
	update_path()
	set_path_refresh_timer()

func update_path() -> void:
	path = get_path_to_player()
	if path.size() > 0:
		agent.set_target_location(path[0])

func get_path_to_player() -> Array:
	var _p = []
	if Game.player:
		_p = Navigation2DServer.map_get_path(
				enemy.get_world_2d().get_navigation_map(),
				enemy.global_position,
				Game.player.global_position,
				false)
	else:
		printerr("Player doesn't exist")
	return _p

func physics_process(delta : float) -> String:
	if path.empty():
		update_path()
	
	if !path.empty():
		var _position = enemy.global_position
		var _next_location = agent.get_next_location()
		var _velocity = _position.direction_to(_next_location) * speed
		agent.set_velocity(_velocity)
		
		if _position.distance_to(_next_location) < threshold:
			path.remove(0)
			if !path.empty():
				agent.set_target_location(path[0])
	
	if enemy.player_close:
		return "WindUp"
	else:
		return KEEP_STATE

func exit() -> void:
	disconnect_from_agent()

func _on_velocity_computed(safe_velocity : Vector2) -> void:
	var _position = enemy.position
	enemy.move_and_slide(safe_velocity)
	sprite.flip_h = (enemy.position.x - _position.x) == -1.0
