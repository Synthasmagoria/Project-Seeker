	extends KinematicBody2D

# TODO: Move state specific variables into their respective classes
## The speed at which the player walks
var walk_speed := 150.0
## The accumulated velocity
var velocity := Vector2.ZERO
## The force of the gravity that pulls the player downwards
var gravity := 800.0
## What direction is up
var up := Vector2.UP
## A copy of position from the previous frame of movement
var previous_position : Vector2
## Length of the vector that is opposite to up
var snap_distance := 4.0
## Direction that the player is facing
var facing := 1.0
##
var cast_speed := 1000.0
## Platform that is currently stood on
var platform : KinematicBody2D setget set_platform
func set_platform(val : KinematicBody2D) -> void:
	if val && !platform:
		emit_signal("entered_platform", val)
	elif !val && platform:
		emit_signal("exited_platform", platform)
	platform = val
## The velocity of the collided platform
var platform_velocity : Vector2
##
var platform_dashed : bool
##
export(PackedScene) var spell_scene
##
var airjump_count := 0
##
var airjump_number := 1
##
var dead = false
##
var boosted = false

## The state machine dictating player behavior
onready var state_machine := $StateMachine

signal entered_platform(plat)
signal exited_platform(plat)

func refresh_airjumps() -> void:
	airjump_count = 0

func add_airjump() -> void:
	airjump_count -= 1

func remove_airjumps() -> void:
	airjump_count = airjump_number

func count_airjump() -> void:
	airjump_count = min(airjump_count + 1, airjump_number)

func can_airjump() -> bool:
	return airjump_count < airjump_number

func is_dead() -> bool:
	return state_machine.get_current_state().name == "Dead"

static func get_snap_vector(length : float, v_up : Vector2) -> Vector2:
	return v_up * -length

static func get_walk_input() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")

static func kinematic_collision_get_platform(col : KinematicCollision2D) -> KinematicBody2D:
	if col.collider is KinematicBody2D && Math.int_get_bit(col.collider.collision_layer, Util.COLLISION_MASK_BIT.PLATFORM):
		return col.collider as KinematicBody2D
	else:
		return null

## Gets an enemy collision from slide collisions
func get_enemy_collision() -> KinematicCollision2D:
	var _col : KinematicCollision2D
	for i in get_slide_count():
		_col = get_slide_collision(i)
		if _col.collider.is_in_group("enemies"):
			return _col
	return null

func get_killer_collision() -> KinematicCollision2D:
	var _col : KinematicCollision2D
	for i in get_slide_count():
		_col = get_slide_collision(i)
		if _col.collider.get_collision_layer_bit(Util.COLLISION_MASK_BIT.KILLER):
			return _col
	return null

##
func get_platform_collision() -> KinematicCollision2D:
	for i in get_slide_count():
		if get_slide_collision(i).collider.get_collision_layer_bit(Util.COLLISION_MASK_BIT.PLATFORM):
			return get_slide_collision(i)
	return null

func shoot() -> void:
	var _projectile = spell_scene.instance()
	_projectile.global_position = global_position
	_projectile.velocity.x = facing * cast_speed
	_projectile.caster = self
	_projectile.connect("enemy_hit", self, "_on_spell_enemy_hit")
	LevelManager.add_to_level(_projectile)

func _on_spell_enemy_hit(enemy) -> void:
	add_airjump()

func _ready() -> void:
	state_machine.init([self])
	Game.player = self

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		shoot()

func velocity_movement(vel : Vector2, snap : bool, walked = true) -> void:
	previous_position = position
	move_and_slide_with_snap(vel, get_snap_vector(snap_distance, up) * float(snap), up)
	
	## Scan slide collisions for platform
	var _plat_col = get_platform_collision()
	if _plat_col:
		set_platform(_plat_col.collider)
		platform_velocity = _plat_col.collider_velocity
		platform_dashed = state_machine.get_current_state().name == "DownDash"
	else:
		set_platform(null)
	
	if walked && previous_position.x != position.x:
		facing = sign(position.x - previous_position.x)
		$Pivot.scale.x = facing

func distance_movement(dist : Vector2) -> void:
	previous_position = position
	move_and_collide(dist)

func _on_Player_tree_exiting() -> void:
	if Game.player == self:
		Game.player = null
