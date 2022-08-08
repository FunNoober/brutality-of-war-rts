extends Control

var is_visible : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enable_debug"):
		if is_visible == true:
			is_visible = false
			$DebugPopup.hide()
		else:
			is_visible = true
			$DebugPopup.show()

func _on_TimerscaleEdit_value_changed(value: float) -> void:
	Engine.time_scale = value

func _on_Add1000MoneyButton_pressed() -> void:
	GlobalVars.current_money += 1000

func _on_SetMoney_value_changed(value: float) -> void:
	GlobalVars.current_money = value

func _on_LoseGameButton_pressed() -> void:
	GlobalVars.completion_mode = GlobalVars.COMPLETE_MODES.defeat

func _on_WinGameButton_pressed() -> void:
	GlobalVars.completion_mode = GlobalVars.COMPLETE_MODES.victory
