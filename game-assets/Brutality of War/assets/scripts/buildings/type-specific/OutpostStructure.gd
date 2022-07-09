extends "res://assets/scripts/buildings/BuildingBase.gd"

var buildings_in_radius = []

func _process(delta: float) -> void:
	if buildings_in_radius.size() > 0:
		for building in buildings_in_radius:
			building.get_parent().is_in_territory = true
	if cur_state == STATES.sell:
		queue_free()
		GlobalVars.current_money += data.cost / 2
		
func _on_TerritoryArea_body_entered(body: Node) -> void:
	if body.is_in_group("building-blueprints") and body.get_parent().data.faction == data.faction:
		buildings_in_radius.append(body)
		body.get_parent().is_in_territory = true

func _on_TerritoryArea_body_exited(body: Node) -> void:
	if body.is_in_group("building-blueprints") and body.get_parent().data.faction == data.faction:
		buildings_in_radius.erase(body)
		body.get_parent().is_in_territory = false
