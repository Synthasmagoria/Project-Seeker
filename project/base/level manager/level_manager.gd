extends Node

## Path pointing to the resource of the currently loaded level
var current_level_path : String
# Current level instance
var _level : Node

const LEVEL_GROUP_NAME = "levels"

## Loads a level using a packed scene and sets
func change(level : PackedScene) -> void:
	clear()
	call_deferred("_set_level", level)

## Loads a level and replaces it with the current level at the end of the frame
func change_from_path(path : String) -> void:
	clear()
	call_deferred("_load_level_from_path", path)

## Reloads the currently loaded room
func reload() -> void:
	change_from_path(current_level_path)

## Removes the current room from the scene tree
func clear() -> void:
	if _level:
		_level.queue_free()
		_level = null
#	for n in $Caducous.get_children():
#		n.queue_free()

## Removes all instances, including persistent ones
func reset() -> void:
	clear()
	for n in $Persistent.get_children():
		n.queue_free()

## Instances a scene that will not be removed by the level manager
func instance_persistent(scene : PackedScene) -> Node:
	var _instance = scene.instance()
	$Persistent.add_child(_instance)
	return _instance

func add_to_level(node : Node) -> void:
	if _level:
		_level.add_child(node)
	else:
		$Caducous.add_child(node)

func get_level() -> Node:
	return _level

## Returns true if there is a level loaded
func is_level_loaded() -> bool:
	return $Caducous.get_child_count() > 0

## Returns true if the passed node is a child of the current level
func is_in_current_level(node : Node) -> bool:
	return _level.is_a_parent_of(node)

func _ready() -> void:
	# When play scene is called on a level this will make sure that
	# it gets added as child of the level manager
	_add_first_in_group()
#	if is_level_loaded():
#		Game.state = Game.STATE.IN_GAME

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		reload()

# Adds first level from a group as child of the level manager
func _add_first_in_group() -> void:
	var _lv = NodeUtil.get_first_node_in_group("levels")
	if _lv:
		_set_level(_lv)

# Loads a level from a path and adds it to the scene tree
func _load_level_from_path(path : String) -> void:
	var _scene = load(path)
	assert(_scene, "LevelManager: Couldn't load level from " + path)
	_set_level(_scene.instance())

# Sets a level as current and adds it to the scene tree
func _set_level(level : Node) -> void:
	var _level_parent = level.get_parent()
	if _level_parent == self:
		push_error("LevelManager: The level is already loaded")
		return
#	if _level_parent:
#		_level_parent.call_deferred("remove_child", level)
	_level = level
	current_level_path = level.filename
	if !_level_parent:
		$Caducous.call_deferred("add_child", level)
