extends "res://assets/scripts/buildings/BuildingBase.gd"

export var enemy_pos_flat : NodePath
export var enemy_position_3d : NodePath
export var turret_gun : NodePath
export var muzzle : NodePath
export var projectile : PackedScene

var targets = []
var can_shoot : bool = true

func _process(delta: float) -> void:
		
	if targets.size() > 0:
		if is_instance_valid(targets[0]) == false:
			targets.remove(0)
			return
		if targets[0] != null:
			if is_instance_valid(targets[0]):
				var node_turret_gun = get_node(turret_gun)
				var node_enemy_pos_flat = get_node(enemy_pos_flat)
				node_enemy_pos_flat.global_transform.origin.x = lerp(node_enemy_pos_flat.global_transform.origin.x, targets[0].global_transform.origin.x, delta * 10)
				node_enemy_pos_flat.global_transform.origin.z = lerp(node_enemy_pos_flat.global_transform.origin.z, targets[0].global_transform.origin.z, delta * 10)
				node_turret_gun.look_at(node_enemy_pos_flat.global_transform.origin, Vector3.UP)
				node_turret_gun.rotation_degrees.y += 90
				get_node(enemy_position_3d).global_transform.origin = lerp(get_node(enemy_position_3d).global_transform.origin, targets[0].global_transform.origin, delta * 10)
				get_node(muzzle).rotation_degrees.y = 90
				shoot()

func shoot():
	if can_shoot:
		can_shoot = false
		var p : RigidBody = projectile.instance()
		get_tree().get_root().add_child(p)
		p.rotation = get_node(muzzle).global_transform.basis.get_euler()
		p.translation = get_node(muzzle).global_transform.origin
		p.set_direction(15, 10)
		$ShootDelay.start()

func _on_Vision_body_entered(body: Node) -> void:
	if body.is_in_group("units"):
		targets.append(body)

func _on_ShootDelay_timeout() -> void:
	can_shoot = true
