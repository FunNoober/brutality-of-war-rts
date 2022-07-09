extends "res://assets/scripts/buildings/BuildingBase.gd"

var queue = []
var queue_data = []

var is_constructing : bool = false

func _ready() -> void:
	for button in $CanvasLayer/Control/Toolbar.get_children():
		button.connect("build_pressed", self, "add_unit_to_queue")
		
func _process(delta: float) -> void:
	if cur_state == STATES.defense:
		if selected == false:
			$CanvasLayer/Control.hide()
		else:
			$CanvasLayer/Control.show()
		
		if queue.size() > 0 and is_constructing == false:
			if has_power:
				$SpawnTimer.start(queue_data[0].cost / 60)
			else:
				$SpawnTimer.start(queue_data[0].cost / 60 * 2)
			is_constructing = true
	if cur_state == STATES.sell:
		queue_free()
		GlobalVars.current_money += data.cost / 2
		
func add_unit_to_queue(to_spawn, u_data):
	queue.append(to_spawn)
	queue_data.append(u_data)

func _on_SpawnTimer_timeout() -> void:
	if queue.size() > 0:
		var unit = queue[0].instance()
		get_node(GlobalVars.active_scene).get_node("Navigation").add_child(unit)
		unit.global_transform.origin = $SpawnPosition.global_transform.origin
		queue.remove(0)
		queue_data.remove(0)
	is_constructing = false
