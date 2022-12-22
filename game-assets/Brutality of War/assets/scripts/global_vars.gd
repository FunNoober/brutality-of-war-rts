extends Node

var global_mouse_pos : Vector3
var global_item_selected : NodePath
var units_selected = []
var nato_units = []
var warsaw_units = []
var nato_buildings = []
var warsaw_buildings = []

var mouse_hovering_ui : bool = false

var active_scene : NodePath
var active_navigation : NodePath

var is_playing : bool = false

var current_money : int = 500
var current_power : int = 10

var player_faction : int = 0

var map_data : Resource

enum STATES {
	normal,
	build_mode,
	sell_mode
}

enum MODES {
	defensive,
	offensive
}

enum COMPLETE_MODES {
	defeat,
	victory
}

var completion_mode

var cur_state = STATES.normal
var cur_mode = MODES.defensive

var global_delta

func _ready() -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	var ui_bus = AudioServer.get_bus_index("UI Sound")
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	var announcer_bus = AudioServer.get_bus_index("Announcer")
	var f = File.new()
	if f.file_exists("user://settings.brutalityofwar"):
		f.open("user://settings.brutalityofwar", f.READ)
		var contents_as_string = f.get_as_text()
		var contents_as_dictionary = parse_json(contents_as_string)
		AudioServer.set_bus_volume_db(master_bus, contents_as_dictionary.master_volume)
		AudioServer.set_bus_volume_db(ui_bus, contents_as_dictionary.ui_sound)
		AudioServer.set_bus_volume_db(music_bus, contents_as_dictionary.music_sound)
		AudioServer.set_bus_volume_db(sfx_bus, contents_as_dictionary.sfx_sound)
		AudioServer.set_bus_volume_db(announcer_bus, contents_as_dictionary.announcer_sound)
		if contents_as_dictionary.windowed == 0:
			OS.window_fullscreen = false
		elif contents_as_dictionary.windowed == 1:
			OS.window_fullscreen = true
			
		if contents_as_dictionary.vsync == 0:
			OS.set_use_vsync(false)
		elif contents_as_dictionary.vsync == 1:
			OS.set_use_vsync(true)

func _process(delta: float) -> void:
	global_delta = delta
	if is_playing:
		if player_faction == 0: # if player is nato
			if nato_buildings.size() <= 0:
				completion_mode = COMPLETE_MODES.defeat
			if warsaw_buildings.size() <= 0:
				completion_mode = COMPLETE_MODES.victory
		if player_faction == 1: # if player is warsaw
			if warsaw_buildings.size() <= 0:
				completion_mode = COMPLETE_MODES.defeat
			if nato_buildings.size() <= 0:
				completion_mode = COMPLETE_MODES.victory
		if completion_mode == COMPLETE_MODES.defeat:
			get_tree().reload_current_scene()
			cur_state = STATES.normal
			completion_mode = null
		if completion_mode == COMPLETE_MODES.victory:
			get_tree().reload_current_scene()
			cur_state = STATES.normal
			completion_mode = null
