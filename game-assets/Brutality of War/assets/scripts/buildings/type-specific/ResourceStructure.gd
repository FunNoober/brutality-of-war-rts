extends "res://assets/scripts/buildings/BuildingBase.gd"

var timer

func _ready() -> void:
	if cur_state == STATES.defense:
		timer = Timer.new()
		timer.connect("timeout", self, "add_resource")
		if has_power:
			timer.wait_time = 1
		else:
			timer.wait_time = 3
		timer.autostart = true
		timer.one_shot = false
		add_child(timer)
	if cur_state == STATES.sell:
		queue_free()
		GlobalVars.current_money += data.cost / 2
	
func _process(delta: float) -> void:
	if has_power:
		timer.wait_time = 1
	else:
		timer.wait_time = 3

func add_resource():
	GlobalVars.current_money += data.resources_per_minute / 60
