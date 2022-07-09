extends Position3D

export var move_speed : float = 50
var selected_units = []
var selected_building : Spatial
var is_holding_modifier : bool

func input(delta):
	var mov_x = calcute_movement("move_left", "move_right", delta)
	global_translate(get_global_transform().basis.x.normalized() * -mov_x)
	var mov_z = calcute_movement("move_up", "move_down", delta)
	global_translate(get_global_transform().basis.z.normalized() * -mov_z)
	rotation.y -= calcute_movement("rotate_left", "rotate_right", delta) * 0.1
	
func calcute_movement(action_one : String, action_two : String, delta : float):
	var mov = (Input.get_action_strength(action_one) - Input.get_action_strength(action_two)) * delta * move_speed
	return mov
	
func _process(delta: float) -> void:
	input(delta)
	
	match GlobalVars.cur_state:
		GlobalVars.STATES.build_mode:
			mouse_ray(1)
		GlobalVars.STATES.sell_mode:
			mouse_ray(2)
		GlobalVars.STATES.normal:
			mouse_ray(2)
	is_holding_modifier = Input.is_action_pressed("modifier")
	
	if GlobalVars.cur_state == GlobalVars.STATES.normal:
		if GlobalVars.global_item_selected != "" and get_node(GlobalVars.global_item_selected).is_in_group("units") and GlobalVars.mouse_hovering_ui == false:
			if is_holding_modifier and Input.is_action_just_pressed("confirm_build"):
				selected_units.append(get_node(GlobalVars.global_item_selected))
				get_node(GlobalVars.global_item_selected).selected = true
				if selected_building != null:
					selected_building.selected = false
			if !is_holding_modifier and Input.is_action_just_pressed("confirm_build"):
				for unit in selected_units:
					if is_instance_valid(unit):
						unit.selected = false
				selected_units.clear()
				selected_units.append(get_node(GlobalVars.global_item_selected))
				get_node(GlobalVars.global_item_selected).selected = true
				if selected_building != null:
					selected_building.selected = false
		if GlobalVars.global_item_selected != "" and get_node(GlobalVars.global_item_selected).is_in_group("buildings") and GlobalVars.mouse_hovering_ui == false:
			if Input.is_action_just_pressed("confirm_build"):
				if selected_building != null:
					selected_building.selected = false
				selected_building = get_node(GlobalVars.global_item_selected).get_parent()
				selected_building.selected = true
				for unit in selected_units:
					if is_instance_valid(unit):
						unit.selected = false
				selected_units.clear()
	
	if GlobalVars.cur_state == GlobalVars.STATES.sell_mode and Input.is_action_just_pressed("confirm_build") and GlobalVars.mouse_hovering_ui == false:
		if GlobalVars.global_item_selected != "" and get_node(GlobalVars.global_item_selected).is_in_group("buildings"):
			var building_selected = get_node(GlobalVars.global_item_selected).get_parent()
			if building_selected.data.faction == building_selected.data.FACTIONS.NATO:
				building_selected.cur_state = building_selected.STATES.sell
	
	if Input.is_action_just_pressed("cancel_build") and get_node(GlobalVars.global_item_selected).get_groups().size() > 0 and GlobalVars.mouse_hovering_ui == false:
		match get_node(GlobalVars.global_item_selected).get_groups()[0]:
			"ground":
				var angle = 0
				for unit in selected_units:
					if is_instance_valid(unit):
						if selected_units.size() >= 2:
							unit.move_to(GlobalVars.global_mouse_pos + Vector3(cos(angle), 0, sin(angle)) * unit.data.attack_range)
							unit.state = unit.STATE.moving
							angle += 2.0*PI / 12
						else:
							unit.move_to(GlobalVars.global_mouse_pos)
							unit.state = unit.STATE.moving
			"buildings":
				var angle = 0
				for unit in selected_units:
					if is_instance_valid(unit):
						if get_node(GlobalVars.global_item_selected).get_parent().data.faction != unit.data.faction:
							unit.move_to(GlobalVars.global_mouse_pos + Vector3(cos(angle), 0, sin(angle)) * unit.data.attack_range)
							unit.state = unit.STATE.attack_move
							unit.attack_init(get_node(GlobalVars.global_item_selected).global_transform.origin)
							angle += 2.0*PI / 12
			
	if !is_holding_modifier and Input.is_action_just_pressed("confirm_build") and GlobalVars.mouse_hovering_ui == false:
		if GlobalVars.global_item_selected != "":
			if get_node(GlobalVars.global_item_selected).is_in_group("ground"):
				for unit in selected_units:
					if is_instance_valid(unit):
						unit.selected = false
				selected_units.clear()
				if selected_building != null and is_instance_valid(selected_building):
					selected_building.selected = false

func mouse_ray(collision_mask):
	var space_state = get_world().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = $Camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + $Camera.project_ray_normal(mouse_pos) * 2000
	var intersection = space_state.intersect_ray(ray_origin, ray_end, [], collision_mask)
	
	if not intersection.empty():
		GlobalVars.global_mouse_pos = intersection.position
		GlobalVars.global_item_selected = intersection.collider.get_path()