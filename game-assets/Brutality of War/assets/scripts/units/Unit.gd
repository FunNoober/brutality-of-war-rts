extends KinematicBody
class_name Unit

enum STATE {
	idle,
	moving,
	attack_move,
	attacking,
	dead
}

var move_speed : float = 4.0

var state = STATE.idle
var can_attack : bool = true
var cur_health : int = 100
var selected : bool
var path = []
var path_ind : int = 0
var target : Vector3
var dir_to_face : float
var lookdir : float
var move_vec : Vector3
var target_pos : Vector3

export var projectile : PackedScene
export var data : Resource
export var selected_marker : NodePath
export var muzzle : NodePath
export var shoot_timer : NodePath
export var vision : NodePath
export var left_whisker : NodePath
export var right_whisker : NodePath

func _ready() -> void:
	cur_health = data.health
	get_node(vision).connect("body_entered", self, "vision_entered")

func attack_init(new_target):
	target = new_target
	
func _process(delta: float) -> void:
	if selected == true and get_node(selected_marker).is_visible_in_tree() == false:
		get_node(selected_marker).show()
	if selected == false and get_node(selected_marker).is_visible_in_tree() == true:
		get_node(selected_marker).hide()

func _physics_process(delta):
	if cur_health <= 0:
		state = STATE.dead
	match state:
		STATE.idle:
			dir_to_face = 0
		STATE.moving:
			do_moving()
		STATE.attack_move:
			do_attack_moving()
		STATE.attacking:
			do_attacking()
		STATE.dead:
			queue_free()
 
			
func look_while_move(move_vec):
	if state != STATE.idle and state != STATE.attacking:
		if get_node(left_whisker).is_colliding() and get_node(right_whisker).is_colliding() == false:
			dir_to_face -= 0
		if get_node(right_whisker).is_colliding() and get_node(left_whisker).is_colliding() == false:
			dir_to_face -= 0
		if get_node(left_whisker).is_colliding() == false and get_node(right_whisker).is_colliding() == false:
			dir_to_face = 0
		lookdir = atan2(-move_vec.x + dir_to_face, -move_vec.z + dir_to_face)
		rotation.y = lerp(rotation.y, lookdir, GlobalVars.global_delta * 5)
			
func do_attack_moving():
	if path_ind < path.size():
		move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1] - global_transform.origin).length() < 1:
			state = STATE.attacking
		else:
			look_while_move(move_vec)
			move_and_slide(-transform.basis.z * move_speed, Vector3(0, 1, 0))
			
func do_moving():
	if path_ind < path.size():
		move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1]).distance_to(global_transform.origin) < 1:
			state = STATE.idle
		else:
			look_while_move(move_vec)
			move_and_slide(-transform.basis.z * move_speed, Vector3(0, 1, 0))
			
func do_attacking():
	var look_at_pos = target
	look_at_pos.x = stepify(look_at_pos.x, 0.001)
	look_at_pos.z = stepify(look_at_pos.z, 0.001)
	look_at_pos.y = global_transform.origin.y
	look_at(look_at_pos, Vector3.UP)
	attack()

func attack():
	if can_attack:
		can_attack = false
		var p : RigidBody = projectile.instance()
		get_tree().get_root().add_child(p)
		p.rotation = get_node(muzzle).global_transform.basis.get_euler()
		p.translation = get_node(muzzle).global_transform.origin
		p.set_direction(25, data.damage)
		get_node(shoot_timer).start()

func move_to(target_pos):
	target_pos = target_pos
	path = get_node(GlobalVars.active_navigation).get_simple_path(translation, target_pos)
	path_ind = 0

func _on_ShootTimer_timeout() -> void:
	can_attack = true

func vision_entered(body: Node) -> void:
	if body.is_in_group("units") and body.data.faction != data.faction:
		if state == STATE.idle:
			move_to(body.global_transform.origin)
			state = STATE.attack_move
