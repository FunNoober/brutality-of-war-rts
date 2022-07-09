extends RigidBody

var damage : int = 10
export var data : Resource

func _ready() -> void:
	connect("body_entered", self, "_on_Bullet_body_entered")

func _process(delta: float) -> void:
	if $RayCast.is_colliding() and $RayCast.get_collider() != null:
		if $RayCast.get_collider().is_in_group("buildings"):
			if $RayCast.get_collider().get_parent().data.faction != data.faction:
				$RayCast.get_collider().get_parent().cur_health -= damage
		if $RayCast.get_collider().is_in_group("units"):
			if $RayCast.get_collider().data.faction != data.faction:
				$RayCast.get_collider().cur_health -= damage
		queue_free()

func set_direction(force, dmg):
	apply_impulse(global_transform.origin, global_transform.basis.z * force)
	damage = dmg

func _on_Bullet_body_entered(body: Node) -> void:
	if body.get_parent().is_in_group("buildings"):
		if body.get_parent().data.faction != data.faction:
			body.get_parent().cur_health -= damage
	if body.is_in_group("units"):
		if body.data.faction != data.faction:
			body.cur_health -= damage
	queue_free()


func _on_Lifetime_timeout() -> void:
	queue_free()
