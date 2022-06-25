extends Button

func _on_SellModeButton_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		GlobalVars.cur_state = GlobalVars.STATES.sell_mode
	else:
		GlobalVars.cur_state = GlobalVars.STATES.normal
