extends EditorScript
tool

class_name TechnicalArtistClass

var behaviors : Array

enum BEHAVIOR {FILL, AUTOTILE, ROCKS}

class TileMapBehavior:
	var path : String
	var tile_index : int
	var source_tile_index : int
	var behavior : int
	func _init(pth : String, src_ind : int, ind : int, beh : int) -> void:
		path = pth
		source_tile_index = src_ind
		tile_index = ind
		behavior = beh

var base : TileMap

func add_tilemap_behavior(pth : String, src_ind : int, ind : int, beh : int) -> void:
	behaviors.push_back(TileMapBehavior.new(pth, src_ind, ind, beh))

func set_base(path : String):
	base = get_editor_interface().get_edited_scene_root().get_node_or_null(path)

## It is required that you set a base here using set_base()
## Also add tilemap nodes and algorithms applied here add_tilemap_behavior()
func _init() -> void:
	set_base("Solids")
	add_tilemap_behavior("Middle/Rock", 0, 0, BEHAVIOR.AUTOTILE)
	add_tilemap_behavior("Middle/RockBg", 0, 1, BEHAVIOR.FILL)
	add_tilemap_behavior("Middle/MountainRock", 1, 0, BEHAVIOR.AUTOTILE)
	add_tilemap_behavior("Middle/MountainRockBg", 1, 0, BEHAVIOR.AUTOTILE)

func _run() -> void:
	if !get_editor_interface().get_edited_scene_root() is Level2D:
		printerr("Scene root was not of type Level2D")
		return
	
	for behavior in behaviors:
		var _dest = get_tilemap_from_root(behavior.path)
		match behavior.behavior:
			BEHAVIOR.FILL:
				tilemap_fill(base, behavior.source_tile_index, _dest, behavior.tile_index)
			BEHAVIOR.AUTOTILE:
				tilemap_autotile_3x3min(base, behavior.source_tile_index, _dest, behavior.tile_index)
			BEHAVIOR.ROCKS:
				pass
	
	# TODO: Check if autotile coordinates are offset by tile region position

const INVALID_BITMASK = -1

func tilemap_fill(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int) -> void:
	for v in src.get_used_cells_by_id(src_ind):
		dest.set_cellv(v, dest_ind)

func tilemap_autotile_3x3min(src : TileMap, src_ind : int, dest : TileMap, dest_ind : int) -> void:
	var _a_coords = get_tilemap_autotile_coords(dest, dest_ind)
	for v in src.get_used_cells():
		var _bitmask = tilemap_cell_get_bitmask(base, src_ind, v)
		if _bitmask == INVALID_BITMASK:
			continue
		dest.set_cellv(v, 0, false, false, false, _a_coords[_bitmask])

func find_tilemap_by_name(selection : Array, name : String) -> TileMap:
	for n in selection:
		if n.name == name:
			return n
	return null

func get_tilemap_from_root(path : String) -> TileMap:
	return get_editor_interface().get_edited_scene_root().get_node(path) as TileMap

func get_tilemap_autotile_coords(tilemap : TileMap, ind : int) -> Dictionary:
	var _rect = tilemap.tile_set.tile_get_region(0)
	var _size = tilemap.tile_set.autotile_get_size(0)
	var _a_coords = {}
	for x in range(_rect.position.x, _rect.end.x, _size.x):
		for y in range(_rect.position.y, _rect.end.y, _size.y):
			_a_coords[tilemap.tile_set.autotile_get_bitmask(0, Vector2(x, y) / _size)] = Vector2(x, y) / _size
	return _a_coords

static func tilemap_cell_exists(tilemap : TileMap, pos : Vector2) -> int:
	return int(sign(tilemap.get_cellv(pos) + 1))

func tilemap_cell_index_exists(tilemap : TileMap, ind : int, pos : Vector2) -> int:
	return int(tilemap.get_cellv(pos) == ind)

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
