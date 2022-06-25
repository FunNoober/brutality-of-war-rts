extends KinematicBody
class_name Unit
 
export var data : Resource

var selected : bool
var path = []
var path_ind = 0
const move_speed = 12

var target

enum STATE {
	idle,
	moving,
	attack_move,
	attacking
}

var state = STATE.idle

var can_attack : bool = true
export var projectile : PackedScene

func attack_init(new_target):
	target = new_target
	
func _process(delta: float) -> void:
	if selected == true and $MeshInstance2.is_visible_in_tree() == false:
		$MeshInstance2.show()
	if selected == false and $MeshInstance2.is_visible_in_tree() == true:
		$MeshInstance2.hide()

func _physics_process(delta):
	match state:
		STATE.moving:
			do_moving()
		STATE.attack_move:
			do_attack_moving()
		STATE.attacking:
			do_attacking()
 
func do_attack_moving():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1] - global_transform.origin).length() < 1:
			state = STATE.attacking
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			look_at(transform.origin + move_vec.normalized() * move_speed, Vector3.UP)

func do_moving():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			look_at(transform.origin + move_vec.normalized() * move_speed, Vector3.UP)
	
	
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
		p.rotation = $MeshInstance3/Muzzle.global_transform.basis.get_euler()
		p.translation = $MeshInstance3/Muzzle.global_transform.origin
		p.set_direction(25, data.damage)
		$ShootTimer.start()

func move_to(target_pos):
	path = get_node(GlobalVars.active_navigation).find_path(translation, target_pos)
	path_ind = 0


func _on_ShootTimer_timeout() -> void:
	can_attack = true
