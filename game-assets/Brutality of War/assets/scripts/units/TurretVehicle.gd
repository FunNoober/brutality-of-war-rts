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

var move_speed : float = 10.0
var selected : bool
var vel : Vector3
var target_pos : Vector3
var target : Vector3
var next_node_in_path : Vector3
var can_attack : bool = true
var cur_health : int = 100
var has_spotted_enemy : bool = false

var spotted_body : Spatial

export var selection_marker : NodePath
export var projectile : PackedScene
export var shoot_timer : NodePath
export var muzzle : NodePath
export var muzzle_transform : NodePath
export var gun_base : NodePath
export var vision : NodePath

func _ready() -> void:
	get_node(shoot_timer).connect("timeout", self, "_on_ShootTimer_timeout")
	get_node(vision).connect("body_entered", self, "vision_entered")
	get_node(vision).connect("body_exited", self, "vision_exited")
	$NavigationAgent.connect("navigation_finished", self, "_on_NavigationAgent_navigation_finished")
	$NavigationAgent.connect("velocity_computed", self, "_on_NavigationAgent_velocity_computed")
	cur_health = data.health
	move_speed = data.mov_speed

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
	if has_spotted_enemy:
		attack_init(spotted_body.global_transform.origin)

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
	look_at(target, Vector3.UP)
	get_node(gun_base).rotation_degrees.y = atan2(-target.x, -target.z)
	get_node(muzzle).look_at(target, Vector3.UP)
	attack()

func attack_init(new_target):
	target = new_target

func attack():
	if can_attack:
		can_attack = false
		var p : RigidBody = projectile.instance()
		get_tree().get_root().add_child(p)
		p.global_transform = get_node(muzzle_transform).global_transform
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

func vision_entered(body):
	if body.is_in_group("units"):
		if body.data.faction != data.faction:
			attack_init(body.global_transform.origin)
			state = STATE.attacking
			spotted_body = body
			has_spotted_enemy = true

func vision_exited(body):
	if body.is_in_group("units"):
		if body.data.faction != data.faction:
			state = STATE.idle
			spotted_body = null
			has_spotted_enemy = false
