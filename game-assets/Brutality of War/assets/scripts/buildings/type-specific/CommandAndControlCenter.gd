extends "res://assets/scripts/buildings/BuildingBase.gd"

func _physics_process(delta: float) -> void:
	match data.faction:
		data.FACTIONS.NATO:
			for unit in GlobalVars.nato_units:
				if is_instance_valid(unit):
					unit.command_bonus = true
