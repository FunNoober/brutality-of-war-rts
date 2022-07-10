extends Node

var global_mouse_pos : Vector3
var global_item_selected : NodePath
var units_selected = []

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

var cur_state = STATES.normal
