extends KinematicBody
class_name Unit

export var data : Resource

enum STATE {
	idle,
	move,
	attack,
	dead
}

var state = STATE.idle

var mov_speed : float = 10.0
var selected : bool
var vel : Vector3
var target : Spatial
var target_position : Vector3
var next_node_in_path : Vector3
var can_attack : bool = true
var cur_health : int = 100
var has_spotted_enemy : bool = false
var spotted_enemy : Spatial

export var selection_marker : NodePath
export var projectile : PackedScene
export var shoot_timer : NodePath
export var muzzle : NodePath
export var muzzle_transform : NodePath
export var vision : NodePath

func _ready() -> void:
#	get_node(shoot_timer).connect("timeout", self, "_on_ShootTimer_timeout")
#	get_node(vision).connect("body_entered", self, "vision_entered")
#	get_node(vision).connect("body_exited", self, "vision_exited")
	$NavigationAgent.connect("navigation_finished", self, "_on_NavigationAgent_navigation_finished")
	cur_health = data.health
	mov_speed = data.mov_speed

func _process(delta: float) -> void:
	if selected == true and get_node(selection_marker).is_visible_in_tree() == false:
		get_node(selection_marker).show()
	if selected == false and get_node(selection_marker).is_visible_in_tree() == true:
		get_node(selection_marker).hide()
		
func _physics_process(delta: float) -> void:
	if cur_health <= 0:
		state = STATE.dead
		
	match state:
		STATE.move:
			do_move(delta)
#		STATE.attack:
#			do_attack()
		STATE.dead:
			queue_free()

func do_move(delta):
	next_node_in_path = $NavigationAgent.get_next_location()
	var dir = global_transform.origin.direction_to(next_node_in_path)
	vel = dir * mov_speed * delta
	move_and_slide(vel * 100)

func move_to(target_position):
	$NavigationAgent.set_target_location(target_position)
	state = STATE.move
	
func _on_NavigationAgent_navigation_finished() -> void:
	if state == STATE.move:
		state = STATE.idle

func attack_init(obj):
	target = obj
