extends Spatial

func _ready() -> void:
	GlobalVars.active_scene = get_path()
	GlobalVars.active_navigation = $AStar.get_path()
