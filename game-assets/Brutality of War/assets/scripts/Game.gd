extends Node

export var game : bool = false

func _ready() -> void:
	GlobalVars.active_scene = get_path()
	if game:
		GlobalVars.active_navigation = $Navigation.get_path()
		GlobalVars.is_playing = true
		var d = GlobalVars.dialog_box.instance()
		d.initialize(null, "Central Command", "Command Interface : Load Complete \nObjective: Defend the outpost", 5)
		add_child(d)
	else:
		GlobalVars.is_playing = false
