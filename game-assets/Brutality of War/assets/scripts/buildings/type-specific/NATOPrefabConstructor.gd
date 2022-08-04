extends "res://assets/scripts/buildings/BuildingBase.gd"

func _process(delta: float) -> void:
	if selected == true and $BuildUI/Control/ControlButtons.is_visible_in_tree() == false:
		$BuildUI/Control/ControlButtons.show()
	if selected == false and $BuildUI/Control/ControlButtons.is_visible_in_tree() == true:
		$BuildUI/Control/ControlButtons.hide()
