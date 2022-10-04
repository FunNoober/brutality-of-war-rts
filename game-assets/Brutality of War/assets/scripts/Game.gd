extends Node

export var game : bool = false

func _ready() -> void:
	GlobalVars.active_scene = get_path()
	if game:
		GlobalVars.active_navigation = $Navigation.get_path()
		GlobalVars.is_playing = true
	else:
		GlobalVars.is_playing = false
