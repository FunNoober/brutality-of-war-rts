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
var vel : Vector3
var target_pos : Vector3
var target : Vector3
var next_node_in_path : Vector3
var can_attack : bool = true
var cur_health : int = 100

export var selection_marker : NodePath
export var projectile : PackedScene
export var shoot_timer : NodePath
export var muzzle : NodePath

func _ready() -> void:
	get_node(shoot_timer).connect("timeout", self, "_on_ShootTimer_timeout")
	$NavigationAgent.connect("navigation_finished", self, "_on_NavigationAgent_navigation_finished")
	$NavigationAgent.connect("velocity_computed", self, "_on_NavigationAgent_velocity_computed")
	cur_health = data.health

func _process(delta: float) -> void:
	if selected == true and get_node(selection_marker).is_visible_in_tree() == false:
		get_node(selection_marker).show()
	if selected == false and get_node(selection_marker).is_visible_in_tree() == true:
		get_node(selection_marker).hide()

func _physics_process(delta: float) -> void:
	match state:
		STATE.moving:
			do_moving(delta)
		STATE.attack_move:
			do_moving(delta)
		STATE.attacking:
			do_attacking()
		STATE.dead:
			pass

func look_while_move():
	rotation.y = atan2(-vel.x, -vel.z) #using look_at() is inconsistent

func do_moving(delta):
	next_node_in_path = $NavigationAgent.get_next_location()
	var dir = global_transform.origin.direction_to(next_node_in_path)
	var steering = (dir - vel) * delta * move_speed
	vel += steering
	look_while_move()
	$NavigationAgent.set_velocity(vel * delta * move_speed)
			
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

func move_to(target_pos_loc):
	$NavigationAgent.set_target_location(target_pos_loc)

func _on_NavigationAgent_velocity_computed(safe_velocity: Vector3) -> void:
	move_and_collide(safe_velocity)

func _on_NavigationAgent_navigation_finished() -> void:
	if state == STATE.attack_move:
		state = STATE.attacking
	if state == STATE.moving:
		state = STATE.idle
