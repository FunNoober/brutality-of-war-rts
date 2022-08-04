extends Button

export var building_blueprint : PackedScene
export var building_data : Resource

func _ready() -> void:
	connect("pressed", self, "_on_BuildButton_pressed")

func _process(delta: float) -> void:
	disabled = (building_data.cost >= GlobalVars.current_money)

func _on_BuildButton_pressed() -> void:
	var bb = building_blueprint.instance()
	get_node(GlobalVars.active_scene).add_child(bb)
	GlobalVars.cur_state = GlobalVars.STATES.build_mode
