extends KinematicBody
class_name Unit

enum STATE {
	idle,
	moving,
	attack_move,
	attacking,
	dead
}

export var move_speed : float = 8.0

var state = STATE.idle
var can_attack : bool = true
var cur_health : int = 100
var selected : bool
var target : Vector3
var next_node_in_path : Vector3
var command_bonus : bool = false
var has_applied_bonus : bool = false
var vel = Vector3.ZERO
var anim : AnimationPlayer

var spotted_body : Spatial
var has_spotted_enemy : bool = false

export var projectile : PackedScene
export var data : Resource
export var selected_marker : NodePath
export var muzzle : NodePath
export var muzzle_transform : NodePath
export var shoot_timer : NodePath
export var vision : NodePath
export var anim_player : NodePath
export var feet : NodePath

export (float, 0, 5) var bullet_spread

func _ready() -> void:
	cur_health = data.health
	get_node(vision).connect("body_entered", self, "vision_entered")
	$NavigationAgent.connect("velocity_computed", self, "velocity_computed")
	$NavigationAgent.connect("navigation_finished", self, "navigation_finished")
	
	anim = get_node(str(anim_player) + "/AnimationPlayer")
	
	
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
	
	#global_transform.origin.y = get_node(feet).get_collision_point().y
	match state:
		STATE.idle:
			anim.play("idle")
		STATE.moving:
			do_moving(delta)
			anim.play("run")
		STATE.attack_move:
			do_moving(delta)
			anim.play("run")
		STATE.attacking:
			do_attacking()
			anim.play("idle")
		STATE.dead:
			queue_free()
	
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
	var look_at_pos = target
	look_at_pos.y = global_transform.origin.y
	look_at(look_at_pos, Vector3.UP)
	get_node(muzzle).look_at(target, Vector3.UP)
	attack()

func attack():
	if can_attack:
		can_attack = false
		var p : RigidBody = projectile.instance()
		get_tree().get_root().add_child(p)
		randomize()
		get_node(muzzle_transform).rotation_degrees.y += rand_range(-1, 1) * bullet_spread
		get_node(muzzle_transform).rotation_degrees.x += rand_range(-1, 1) * bullet_spread
		p.global_transform = get_node(muzzle_transform).global_transform
		p.scale = Vector3(1,1,1)
		p.set_direction(25, data.damage)
		get_node(shoot_timer).start(data.attack_rate)

func move_to(target_pos_loc):
	$NavigationAgent.set_target_location(target_pos_loc)
	
func _on_ShootTimer_timeout() -> void:
	can_attack = true 

func vision_entered(body: Node) -> void:
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

func velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)

func navigation_finished():
	if state == STATE.attack_move:
		state = STATE.attacking
	if state == STATE.moving:
		state = STATE.idle
