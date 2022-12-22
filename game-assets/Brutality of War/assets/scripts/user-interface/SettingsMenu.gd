extends Control

var master_volume : float
var ui_volume : float
var music_volume : float
var sfx_volume : float
var announcer_volume : float

var master_bus
var ui_bus
var music_bus
var sfx_bus
var announcer_bus

var data_to_store = {
	"master_volume" : 0.0,
	"ui_sound" : -5.0,
	"music_sound" : 0.0,
	"sfx_sound" : 0.0,
	"announcer_sound" : 0.0,
	"windowed" : 0,
	"vsync" : 0,
	"fov" : 80
}

func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	ui_bus = AudioServer.get_bus_index("UI Sound")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	announcer_bus = AudioServer.get_bus_index("Announcer")
	var f = File.new()
	if f.file_exists("user://settings.brutalityofwar"):
		f.open("user://settings.brutalityofwar", f.READ)
		var contents_as_string = f.get_as_text()
		var contents_as_dictionary = parse_json(contents_as_string)
		$HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/MasterSound.value = contents_as_dictionary.master_volume
		$HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/UISound.value = contents_as_dictionary.ui_sound
		$HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/MusicSound.value = contents_as_dictionary.music_sound
		$HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/SFXSound.value = contents_as_dictionary.sfx_sound
		$HBoxContainer/AudioSettings/HBoxContainer/VBoxContainer2/AnnouncerSound.value = contents_as_dictionary.announcer_sound
		$HBoxContainer/VideoSettings/WindowedOption.select(contents_as_dictionary.windowed)
		$HBoxContainer/VideoSettings/VsyncOption.select(contents_as_dictionary.vsync)
		$HBoxContainer/VideoSettings/HBoxContainer/FOVSlider.value = contents_as_dictionary.fov
		

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, master_volume)
	AudioServer.set_bus_volume_db(ui_bus, ui_volume)
	AudioServer.set_bus_volume_db(music_bus, music_volume)
	AudioServer.set_bus_volume_db(sfx_bus, sfx_volume)
	AudioServer.set_bus_volume_db(announcer_bus, announcer_volume)

func _on_OptionButton_item_selected(index: int) -> void:
	if index == 0:
		OS.window_fullscreen = false
	elif index == 1:
		OS.window_fullscreen = true
	data_to_store.windowed = index
	save()

func _on_OptionButton2_item_selected(index: int) -> void:
	if index == 0:
		OS.set_use_vsync(false)
	elif index == 1:
		OS.set_use_vsync(true)
	data_to_store.vsync = index
	save()

func _on_FOVSlider_value_changed(value: float) -> void:
	data_to_store.fov = value
	save()

func save():
	var f = File.new()
	f.open("user://settings.brutalityofwar", f.WRITE)
	f.store_string(JSON.print(data_to_store))
	f.close()

func _on_MasterSound_value_changed(value: float) -> void:
	master_volume = value
	data_to_store.master_volume = value
	save()

func _on_UISound_value_changed(value: float) -> void:
	ui_volume = value
	data_to_store.ui_sound = value
	save()

func _on_SFXSound_value_changed(value: float) -> void:
	sfx_volume = value
	data_to_store.sfx_sound = value
	save()

func _on_AnnouncerSound_value_changed(value: float) -> void:
	announcer_volume = value
	data_to_store.announcer_sound = value
	save()

func _on_MusicSound_value_changed(value: float) -> void:
	music_volume = value
	data_to_store.music_sound = value
	save()

func _on_CheatMenuButton_toggled(button_pressed: bool) -> void:
	GlobalVars.cheat_menu_enabled = button_pressed
