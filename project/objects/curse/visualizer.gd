extends Sprite

class_name CurseVisualizer2D

func _ready() -> void:
	texture = CurseUtil.get_curseport(self).get_texture()
	var _smat = ShaderMaterial.new()
	_smat.shader = preload("res://objects/curse/curse.gdshader")
	material = _smat
