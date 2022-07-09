extends "res://assets/scripts/buildings/BuildingBase.gd"

var buildings_in_radius = []
export var power_area : NodePath

func _ready() -> void:
	get_node(power_area).connect("body_entered", self, "add_building")

func _physics_process(delta: float) -> void:
	if cur_state == STATES.defense:
		for building in buildings_in_radius:
			if is_instance_valid(building) == true:
				building.has_power = true
	if cur_state == STATES.sell:
		for building in buildings_in_radius:
			if is_instance_valid(building) == true:
				building.has_power = false
		queue_free()
		GlobalVars.current_money += data.cost / 2

func add_building(body: Object):
	if body.is_in_group("buildings"):
		buildings_in_radius.append(body.get_parent())
		buildings_in_radius.append(body.get_parent())
