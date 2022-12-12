extends Control

func _process(delta: float) -> void:
	var ui_sound = AudioServer.get_bus_index("UI Sound")
	AudioServer.set_bus_volume_db(1, $HBoxContainer/AudioSettings/HBoxContainer/UISound.value)
