extends Button

export var building_blueprint : PackedScene

func _ready() -> void:
	connect("pressed", self, "_on_BuildButton_pressed")

func _on_BuildButton_pressed() -> void:
	var bb = building_blueprint.instance()
	get_node(GlobalVars.active_scene).add_child(bb)
	GlobalVars.cur_state = GlobalVars.STATES.build_mode
