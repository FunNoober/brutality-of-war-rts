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
