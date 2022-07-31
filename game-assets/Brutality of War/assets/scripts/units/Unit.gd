extends KinematicBody
class_name Unit

enum STATE {
	idle,
	moving,
	attack_move,
	attacking,
	dead
}

var move_speed : float = 8.0

var state = STATE.idle
var can_attack : bool = true
var cur_health : int = 100
var selected : bool
var path = []
var path_ind : int = 0
var target : Vector3
var move_vec : Vector3
var target_pos : Vector3
var command_bonus : bool = false
var has_applied_bonus : bool = false

export var projectile : PackedScene
export var data : Resource
export var selected_marker : NodePath
export var muzzle : NodePath
export var shoot_timer : NodePath
export var vision : NodePath

func _ready() -> void:
	cur_health = data.health
	get_node(vision).connect("body_entered", self, "vision_entered")
	if data.faction == data.FACTIONS.NATO:
		GlobalVars.nato_units.append(self)
	if data.faction == data.FACTIONS.WarsawPact:
		GlobalVars.warsaw_units.append(self)
	move_speed = data.mov_speed

func attack_init(new_target):
	target = new_target
	
func _process(delta: float) -> void:
	if selected == true and get_node(selected_marker).is_visible_in_tree() == false:
		get_node(selected_marker).show()
	if selected == false and get_node(selected_marker).is_visible_in_tree() == true:
		get_node(selected_marker).hide()
	if command_bonus == true and has_applied_bonus == false:
		data.attack_rate = data.attack_rate * 0.75
		data.health = data.health * 2
		move_speed = move_speed * 1.75
		has_applied_bonus = true

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
 
			
func look_while_move():
	look_at(transform.origin + move_vec.normalized() * move_speed, Vector3.UP)
			
func do_attack_moving():
	if path_ind < path.size():
		move_vec = Vector3()
		move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1] - global_transform.origin).length() < 1:
			state = STATE.attacking
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			look_while_move()
			
func do_moving():
	if path_ind < path.size():
		move_vec = Vector3()
		move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 1:
			path_ind += 1
		if (path[path.size() - 1]).distance_to(global_transform.origin) < 1:
			state = STATE.idle
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			look_while_move()
			
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
		get_node(shoot_timer).start(data.attack_rate)

func move_to(target_pos_loc):
	target_pos = target_pos_loc
	path = get_node(GlobalVars.active_navigation).get_simple_path(global_transform.origin, target_pos_loc)
	path_ind = 0

func _on_ShootTimer_timeout() -> void:
	can_attack = true

func vision_entered(body: Node) -> void:
	if body.is_in_group("units") and body.data.faction != data.faction:
		if state == STATE.idle:
			move_to(body.global_transform.origin)
			state = STATE.attack_move
