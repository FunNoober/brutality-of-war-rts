extends Spatial

export var data : Resource
var cur_health : int = 100
var selected : bool = false
var has_power : bool = false

enum STATES {
	defense,
	sell
}

var cur_state = STATES.defense

func _ready() -> void:
	cur_health = data.health
	if data.faction == data.FACTIONS.NATO:
		GlobalVars.nato_buildings.append(self)
	if data.faction == data.FACTIONS.WarsawPact:
		GlobalVars.warsaw_buildings.append(self)

func _process(delta: float) -> void:
	if cur_health <= 0:
		queue_free()
	if cur_state == STATES.sell:
		queue_free()
		GlobalVars.current_money += data.cost / 2
