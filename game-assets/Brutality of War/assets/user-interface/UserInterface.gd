extends Control

func _process(delta: float) -> void:
	$MoneyLabel.text = "$" + str(GlobalVars.current_money)
