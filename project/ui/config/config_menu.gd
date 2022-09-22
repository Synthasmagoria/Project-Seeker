extends Control

var current_remap : String
export(NodePath) var remapper_path

func _ready() -> void:
	get_node(remapper_path).connect("toggled_active", self, "_on_remapper_toggled_active")

func _on_remapper_toggled_active(active : bool) -> void:
	if !active:
		update_labels()

func update_labels() -> void:
	for n in get_children():
		if n is ActionLine:
			n.update_labels(n.action)

func request_remap(remapper : Object, action : String):
	remapper.prompt_remap(action)

func _on_remap_requested(action) -> void:
	current_remap = action
	request_remap(get_node(remapper_path), action)

func _on_Reset_pressed() -> void:
	InputMap.load_from_globals()
	Config.save_buttons()
	update_labels()
