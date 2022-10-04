extends KinematicBody
class_name Unit

enum STATE {
	idle,
	attack,
	moving,
	attack_move,
	defend
}

var state = STATE.idle

export var move_speed : float = 8.0

export var data : Resource
export var projectile : PackedScene

export var muzzle : NodePath
export var selected_visual : NodePath
export var vision : NodePath
export var shoot_timer : NodePath
export var nav_agent : NodePath

var selected : bool = false
var target
var waypoint

#func _ready() -> void:
#	get_node(nav_agent).connect("navigation_finished", self, "nav_finished")
#	get_node(nav_agent).connect("velocity_computed", self, "velocity_computed")
#	get_node(vision).connect("body_entered", self, "vision_entered")
#	get_node(vision).connect("body_exited", self, "exited")

func _process(delta: float) -> void:
	if selected == true and get_node(selected_visual).is_visible_in_tree() == false:
		get_node(selected_visual).show()
	if selected == false and get_node(selected_visual).is_visible_in_tree() == true:
		get_node(selected_visual).hide()
	
	match state:
		STATE.idle:
			do_idle()
		STATE.attack:
			do_attack()
		STATE.moving:
			do_move()
		STATE.defend:
			do_defend()

func do_idle():
	pass

func do_attack():
	pass
	
func do_move():
	pass
	
func do_defend():
	pass
