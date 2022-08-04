extends Button

func _process(delta: float) -> void:
	if GlobalVars.cur_state != GlobalVars.STATES.sell_mode and pressed == true:
		pressed = false
		
func _on_SellModeButton_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		GlobalVars.cur_state = GlobalVars.STATES.sell_mode
	else:
		GlobalVars.cur_state = GlobalVars.STATES.normal
	
	
