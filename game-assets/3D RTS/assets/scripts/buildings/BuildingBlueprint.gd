extends Spatial

export var building_to_instance : PackedScene
var can_build : bool = true
var colliding_objects = []
var is_in_territory : bool = false

export var data : Resource

func _ready():
	$Area.connect("body_entered", self, "_on_Area_body_entered")
	$Area.connect("body_exited", self, "_on_Area_body_exited")

func _process(delta: float) -> void:
	if Input.is_action_pressed("control"):
		translation = (GlobalVars.global_mouse_pos / 1).floor() * 1
	else:
		translation = GlobalVars.global_mouse_pos
	
	if colliding_objects.size() > 0 or !is_in_territory:
		can_build = false
	else:
		can_build = true
		
	if !can_build:
		$MeshInstance.material_override.albedo_color = Color(1,0,0,0.5)
	if can_build:
		$MeshInstance.material_override.albedo_color = Color(0,0,1,0.5)
	
	if Input.is_action_just_pressed("rotate_build"):
		rotation_degrees.y += 45
	
	if Input.is_action_pressed("confirm_build") and can_build == true and data.cost <= GlobalVars.current_money and is_in_territory:
		var b = building_to_instance.instance()
		get_parent().add_child(b)
		b.transform = transform
		GlobalVars.cur_state = GlobalVars.STATES.normal
		GlobalVars.current_money -= data.cost
		queue_free()
	if Input.is_action_pressed("cancel_build"):
		GlobalVars.cur_state = GlobalVars.STATES.normal
		queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event as InputEventMouseButton
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					rotation_degrees.y += 15
				BUTTON_WHEEL_DOWN:
					rotation_degrees.y -= 15

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("units") or body.is_in_group("buildings"):
		colliding_objects.append(body)

func _on_Area_body_exited(body: Node) -> void:
	if body.is_in_group("units") or body.is_in_group("buildings"):
		colliding_objects.erase(body)
