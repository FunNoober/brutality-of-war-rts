extends KinematicBody

export var data : Resource

enum STATE {
	idle,
	moving,
	attack_move,
	attacking,
	dead
}

var state = STATE.idle

var move_speed : float = 14.0
var selected : bool
var path = []
var path_ind : int = 0
var lookdir : float
var move_vec : Vector3
var target_pos : Vector3
var target : Vector3
var can_attack : bool = true
var cur_health : int = 100

export var selection_marker : NodePath
export var projectile : PackedScene
export var shoot_timer : NodePath
export var muzzle : NodePath

func _ready() -> void:
	get_node(shoot_timer).connect("timeout", self, "_on_ShootTimer_timeout")
	cur_health = data.health

func _process(delta: float) -> void:
	if selected == true and get_node(selection_marker).is_visible_in_tree() == false:
		get_node(selection_marker).show()
	if selected == false and get_node(selection_marker).is_visible_in_tree() == true:
		get_node(selection_marker).hide()

func _physics_process(delta: float) -> void:
	match state:
		STATE.moving:
			do_moving()
		STATE.attack_move:
			do_attack_moving()
		STATE.attacking:
			do_attacking()
		STATE.dead:
			pass

func look_while_move(move_vec):
	lookdir = atan2(-move_vec.x, -move_vec.z)
	rotation.y = lookdir

func do_moving():
	if path_ind < path.size():
		move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1]).distance_to(global_transform.origin) < 1:
			state = STATE.idle
		else:
			look_while_move(move_vec)
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			
func do_attack_moving():
	if path_ind < path.size():
		move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1] - global_transform.origin).length() < 1:
			state = STATE.attacking
		else:
			look_while_move(move_vec)
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			
func do_attacking():
	var look_at_pos = target
	look_at_pos.x = stepify(look_at_pos.x, 0.001)
	look_at_pos.z = stepify(look_at_pos.z, 0.001)
	look_at_pos.y = global_transform.origin.y
	look_at(look_at_pos, Vector3.UP)
	$Turret/GunBase.look_at(look_at_pos, Vector3.UP)
	attack()

func attack_init(new_target):
	target = new_target

func attack():
	if can_attack:
		can_attack = false
		var p : RigidBody = projectile.instance()
		get_tree().get_root().add_child(p)
		p.rotation = get_node(muzzle).global_transform.basis.get_euler()
		p.translation = get_node(muzzle).global_transform.origin
		p.set_direction(25, data.damage)
		get_node(shoot_timer).start()

func _on_ShootTimer_timeout() -> void:
	can_attack = true

func move_to(target_pos):
	target_pos = target_pos
	path = get_node(GlobalVars.active_navigation).get_simple_path(translation, target_pos)
	path_ind = 0
