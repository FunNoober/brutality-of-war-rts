extends Spatial

export var data : Resource
var cur_health : int = 100
var selected : bool = false
var has_power : bool = false

func _ready() -> void:
	cur_health = data.health

func _process(delta: float) -> void:
	if cur_health <= 0:
		queue_free()
