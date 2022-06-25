extends "res://assets/scripts/buildings/BuildingBase.gd"

func _ready() -> void:
	var timer = Timer.new()
	timer.connect("timeout", self, "add_resource")
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)

func add_resource():
	GlobalVars.current_money += data.resources_per_minute / 60
