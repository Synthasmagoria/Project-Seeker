extends EditorScript
tool

class_name LevelTiling

var behaviors : Array

const INVALID_BITMASK = -1

enum BEHAVIOR {FILL, AUTOTILE, AUTOTILE_ONE_DOWN, ROCKS, SNOW}

const ALGORITHMS = {
	BEHAVIOR.FILL : "tilemap_fill",
	BEHAVIOR.AUTOTILE : "tilemap_autotile_3x3min",
	BEHAVIOR.AUTOTILE_ONE_DOWN : "tilemap_autotile_3x3min_one_down",
	BEHAVIOR.ROCKS : "tilemap_autotile_rocks",
	BEHAVIOR.SNOW : "tilemap_autotile_3x3min_snow"
}

class TilingBehavior:
	var path : String
	var tile_index : int
	var source_tile_index : int
	var behavior : int
	var optional_parameters : Array
	func _init(pth : String, src_ind : int, ind : int, beh : int, opt : Array = []) -> void:
		path = pth
		source_tile_index = src_ind
		tile_index = ind
		behavior = beh
		optional_parameters = opt.duplicate()

var base : TileMap

func add_tiling_behavior(tiling_behavior : TilingBehavior) -> void:
	behaviors.push_back(tiling_behavior)

func set_base(path : String) -> void:
	base = get_editor_interface().get_edited_scene_root().get_node_or_null(path)

## It is required that you set a base here using set_base()
## Also add tilemap nodes and algorithms applied here add_tiling_behavior()
func _init() -> void:
	pass

func _run() -> void:
	if !get_editor_interface().get_edited_scene_root() is Level2D:
		printerr("Scene root was not of type Level2D")
		return
	
	for behavior in behaviors:
		var _arguments = [base, behavior.source_tile_index, get_tilemap_from_root(behavior.path), behavior.tile_index]
		for val in behavior.optional_parameters:
			_arguments.push_back(val)
		print(ALGORITHMS[behavior.behavior])
		callv(ALGORITHMS[behavior.behavior], _arguments)
	# TODO: Check if autotile coordinates are offset by tile region position

## Fills a tilemap with the given tile id
func tilemap_fill(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int) -> void:
	for v in src.get_used_cells_by_id(src_ind):
		dest.set_cellv(v, dest_ind)

## Uses 3x3min tiles to autotile a tilemap
func tilemap_autotile_3x3min(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int) -> void:
	var _a_coords = get_tilemap_autotile_coords(dest, dest_ind)
	for v in src.get_used_cells_by_id(src_ind):
		var _bitmask = tilemap_cell_get_bitmask(src, src_ind, v)
		if _bitmask == INVALID_BITMASK:
			printerr("Invalid bitmask")
			continue
		if !_a_coords.has(_bitmask):
			printerr("Non-existing autotile coordinates for bitmask ", _bitmask, " in tileset ", dest.tile_set.resource_name)
			continue
		dest.set_cellv(v, 0, false, false, false, _a_coords[_bitmask])

## Autotiles all tiles plus one down if there's a solid
func tilemap_autotile_3x3min_one_down(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int) -> void:
	var _tilemap = TileMap.new()
	for v in src.get_used_cells_by_id(src_ind):
		_tilemap.set_cellv(v, 0)
	for v in _tilemap.get_used_cells():
		var _cell = src.get_cellv(v + Vector2.DOWN)
		if _cell != src_ind && _cell != TileMap.INVALID_CELL:
			_tilemap.set_cellv(v + Vector2.DOWN, 0)
	tilemap_autotile_3x3min(_tilemap, 0, dest, dest_ind)
	_tilemap.queue_free()

## Autotiles only free top tiles
func tilemap_autotile_3x3min_snow(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int, exclude : String, exclude_ind : int) -> void:
	var _tilemap = TileMap.new()
	# Get all top tiles
	for v in src.get_used_cells_by_id(src_ind):
		if src.get_cellv(v + Vector2.UP) == TileMap.INVALID_CELL:
			_tilemap.set_cellv(v, 0)
	# Removed tiles that are covered from above by another
	var _exclude = get_tilemap_from_root(exclude)
	for v in _tilemap.get_used_cells():
		if _exclude.get_cellv(v + Vector2.UP) == exclude_ind:
			_tilemap.set_cellv(v, TileMap.INVALID_CELL)
	
	var _a_coord = get_tilemap_autotile_coords(dest, dest_ind)
	for key in _a_coord:
		print(key, ":", _a_coord[key])
	
	tilemap_autotile_3x3min(_tilemap, 0, dest, dest_ind)
	_tilemap.queue_free()

## Autotiles random rectangular rocks onto a tilemap
const ROCK_SIZE_MIN : int = 2
const ROCK_SIZE_MAX : int = 4
const ROCK_NUMBER : int = 24 # per 100 tiles

func tilemap_autotile_rocks(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int) -> void:
	var _cells = src.get_used_cells_by_id(src_ind)
	var _area = Util.tilemap_get_used_rect_by_id(src, src_ind)
	var _number = _cells.size() / 100 * ROCK_NUMBER
	var _rocks = []
	
	# Create random rocks within the area
	for i in _number:
		var _size = Vector2(
			rand_range(ROCK_SIZE_MIN, ROCK_SIZE_MAX),
			rand_range(ROCK_SIZE_MIN, ROCK_SIZE_MAX))
		var _position = Vector2(
				_area.position.x - _size.x + 1 + (randi() % int(_area.size.x + (_size.x - 1) * 2)),
				_area.position.y - _size.y + 1 + (randi() % int(_area.size.y + (_size.y - 1) * 2)))
		_rocks.push_back(Rect2(_position, _size))
	
	var rock_tilemap = TileMap.new()
	
	# Melt all rocks together into one big data structure
	for rock in _rocks:
		for x in range(rock.position.x, rock.end.x):
			for y in range(rock.position.y, rock.end.y):
				rock_tilemap.set_cell(x, y, 0)
	
	# Autotile the rocks onto the destination tilemap
	tilemap_autotile_3x3min(rock_tilemap, 0, dest, dest_ind)
	
	# Clear up after rock tiling algorithm
	_area = dest.get_used_rect()
	for x in range(_area.position.x, _area.end.x):
		for y in range(_area.position.y, _area.end.y):
			if src.get_cell(x, y) != src_ind:
				dest.set_cell(x, y, TileMap.INVALID_CELL)
	
	rock_tilemap.queue_free()

## Looks for a TileMap node using the scene root as a starting point
func get_tilemap_from_root(path : String) -> TileMap:
	return get_editor_interface().get_edited_scene_root().get_node_or_null(path) as TileMap

## Returns all autotile coordinates in a dictionary with the bitmasks as keys
## Note that the autotile coordinates are relative to the tile region
func get_tilemap_autotile_coords(tilemap : TileMap, ind : int) -> Dictionary:
	var _rect = tilemap.tile_set.tile_get_region(ind)
	var _size = tilemap.tile_set.autotile_get_size(ind)
	var _a_coords = {}
	for x in range(0, _rect.size.x, _size.x):
		for y in range(0, _rect.size.y, _size.y):
			_a_coords[tilemap.tile_set.autotile_get_bitmask(ind, Vector2(x, y) / _size)] = Vector2(x, y) / _size
	return _a_coords

## Returns 0 if it doesn't exist, 1 if it does
func tilemap_cell_index_exists(tilemap : TileMap, ind : int, pos : Vector2) -> int:
	return int(tilemap.get_cellv(pos) == ind)

## Returns a bitmask for 3x3min autotiling by checking the surrounding tiles
func tilemap_cell_get_bitmask(tilemap : TileMap, ind : int, pos : Vector2) -> int:
	if !tilemap_cell_index_exists(tilemap, ind, pos):
		return -1
	
	var tl = tilemap_cell_index_exists(tilemap, ind, pos + Vector2(-1, -1))
	var t = tilemap_cell_index_exists(tilemap, ind, pos + Vector2.UP)
	var tr = tilemap_cell_index_exists(tilemap, ind, pos + Vector2(1, -1))
	var l = tilemap_cell_index_exists(tilemap, ind, pos + Vector2.LEFT)
	var r = tilemap_cell_index_exists(tilemap, ind, pos + Vector2.RIGHT)
	var bl = tilemap_cell_index_exists(tilemap, ind, pos + Vector2(-1, 1))
	var b = tilemap_cell_index_exists(tilemap, ind, pos + Vector2.DOWN)
	var br = tilemap_cell_index_exists(tilemap, ind, pos + Vector2(1, 1))
	
	var _bitmask = TileSet.BIND_CENTER
	_bitmask |= t * TileSet.BIND_TOP
	_bitmask |= l * TileSet.BIND_LEFT
	_bitmask |= r * TileSet.BIND_RIGHT
	_bitmask |= b * TileSet.BIND_BOTTOM
	_bitmask |= tl * TileSet.BIND_TOPLEFT * (t & l)
	_bitmask |= tr * TileSet.BIND_TOPRIGHT * (t & r)
	_bitmask |= bl * TileSet.BIND_BOTTOMLEFT * (b & l)
	_bitmask |= br * TileSet.BIND_BOTTOMRIGHT * (b & r)
	
	return _bitmask
