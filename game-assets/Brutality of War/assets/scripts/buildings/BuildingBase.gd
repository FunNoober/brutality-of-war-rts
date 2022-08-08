extends Spatial

export var data : Resource
var cur_health : int = 100
var selected : bool = false
var has_power : bool = false

enum STATES {
	defense,
	sell,
	destroy
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
		cur_state = STATES.destroy
	if cur_state == STATES.sell:
		if data.faction == data.FACTIONS.NATO:
			GlobalVars.nato_buildings.erase(self)
		if data.faction == data.FACTIONS.WarsawPact:
			GlobalVars.warsaw_buildings.erase(self)
		queue_free()
		GlobalVars.current_money += data.cost / 2
	if cur_state == STATES.destroy:
		if data.faction == data.FACTIONS.NATO:
			GlobalVars.nato_buildings.erase(self)
		if data.faction == data.FACTIONS.WarsawPact:
			GlobalVars.warsaw_buildings.erase(self)
		queue_free()
