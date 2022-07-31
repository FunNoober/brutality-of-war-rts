extends Node

var global_mouse_pos : Vector3
var global_item_selected : NodePath
var units_selected = []
var nato_units = []
var warsaw_units = []

var mouse_hovering_ui : bool = false

var active_scene : NodePath
var active_navigation : NodePath

var current_money : int = 500
var current_power : int = 10

var player_faction : int = 0

enum STATES {
	normal,
	build_mode,
	sell_mode
}

enum MODES {
	defensive,
	offensive
}

var cur_state = STATES.normal
var cur_mode = MODES.defensive

var global_delta

func _process(delta: float) -> void:
	global_delta = delta
