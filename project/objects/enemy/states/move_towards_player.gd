extends EnemyState

var player
onready var agent = $"../../NavigationAgent2D"
export(float) var speed = 150.0
export(float) var threshold = 4.0
var path : Array

func connect_to_agent() -> void:
	agent.connect("velocity_computed", self, "_on_velocity_computed")

func disconnect_from_agent() -> void:
	agent.disconnect("velocity_computed", self, "_on_velocity_computed")

func enter() -> void:
	connect_to_agent()

func get_path_to_player() -> Array:
	var _player = NodeUtil.get_first_node_in_group_in_current_level("player")
	var _p = Navigation2DServer.map_get_path(
			enemy.get_world_2d().get_navigation_map(),
			enemy.global_position,
			_player.global_position,
			false)
	return _p

func physics_process(delta : float) -> String:
	if path.empty():
		path = get_path_to_player()
	
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
	enemy.move_and_slide(safe_velocity)
