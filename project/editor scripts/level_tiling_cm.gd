extends LevelTiling
tool

func _init() -> void:
	set_base("Solids")
	add_tiling_behavior(TilingBehavior.new("Middle/Rock", 0, 0, BEHAVIOR.AUTOTILE))
	add_tiling_behavior(TilingBehavior.new("Middle/RockBg", 0, 1, BEHAVIOR.FILL))
	add_tiling_behavior(TilingBehavior.new("Middle/RockBg", 0, 0, BEHAVIOR.ROCKS))
	add_tiling_behavior(TilingBehavior.new("Middle/MountainRock", 1, 0, BEHAVIOR.AUTOTILE_ONE_DOWN))
	add_tiling_behavior(TilingBehavior.new("Middle/MountainRockBg", 1, 0, BEHAVIOR.AUTOTILE_ONE_DOWN))
	add_tiling_behavior(TilingBehavior.new("Middle/Snow", 1, 0, BEHAVIOR.SNOW, ["Background/MountainRock", 0]))
