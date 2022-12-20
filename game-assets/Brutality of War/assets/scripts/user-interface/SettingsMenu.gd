extends Control

func _process(delta: float) -> void:
	#TODO: Save this data to a file
	var ui_sound = AudioServer.get_bus_index("UI Sound")
	var master_sound = AudioServer.get_bus_index("Master")
	var music_sound = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(1, $HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/UISound.value)
	AudioServer.set_bus_volume_db(0, $HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/MasterSound.value)
	AudioServer.set_bus_volume_db(music_sound, $HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/MusicSound.value)

func _on_OptionButton_item_selected(index: int) -> void:
	#TODO: Save this data to a file
	if index == 0:
		OS.window_fullscreen = false
	elif index == 1:
		OS.window_fullscreen = true

func _on_OptionButton2_item_selected(index: int) -> void:
	#TODO: Save this data to a file
	if index == 0:
		OS.set_use_vsync(false)
	elif index == 1:
		OS.set_use_vsync(true)

func _on_FOVSlider_value_changed(value: float) -> void:
	#TODO: Save FOV to JSON file then the camera loads from this JSON
	pass