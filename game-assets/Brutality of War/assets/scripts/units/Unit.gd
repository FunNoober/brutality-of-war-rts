extends KinematicBody
class_name Unit

enum STATE {
	idle,
	moving,
	attack_move,
	attacking,
	dead
}

var move_speed : float = 32.0

var state = STATE.idle
var can_attack : bool = true
var cur_health : int = 100
var selected : bool
var path = []
var path_ind : int = 0
var target : Vector3

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
		STATE.moving:
			do_moving()
		STATE.attack_move:
			do_attack_moving()
		STATE.attacking:
			do_attacking()
		STATE.dead:
			queue_free()
 
func do_attack_moving():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1] - global_transform.origin).length() < 1:
			state = STATE.attacking
		else:
			look_while_move(move_vec)
			if get_node(left_whisker).is_colliding():
				move_vec.x -= 1
			if get_node(right_whisker).is_colliding():
				move_vec.x += 1
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			
func look_while_move(move_vec):
	look_at(transform.origin + move_vec, Vector3.UP)
#	if get_node(left_whisker).is_colliding():
#		rotation_degrees.y += 1
#	if get_node(right_whisker).is_colliding():
#		rotation_degrees.y -= 1
			
func do_moving():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		else:
			look_while_move(move_vec)
			if get_node(left_whisker).is_colliding():
				move_vec.x -= 1
			if get_node(right_whisker).is_colliding():
				move_vec.x += 1
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
	
	
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
	path = get_node(GlobalVars.active_navigation).get_simple_path(translation, target_pos)
	path_ind = 0

func _on_ShootTimer_timeout() -> void:
	can_attack = true

func vision_entered(body: Node) -> void:
	if body.is_in_group("units") and body.data.faction != data.faction:
		if state == STATE.idle:
			move_to(body.global_transform.origin)
			state = STATE.attack_move
