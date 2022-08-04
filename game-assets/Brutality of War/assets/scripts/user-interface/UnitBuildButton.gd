extends Button

export var unit_to_spawn : PackedScene
export var unit_data : Resource

signal build_pressed(to_spawn, u_data)

func _ready() -> void:
	connect("pressed", self, "button_pressed")
	
func _process(delta: float) -> void:
	disabled = (unit_data.cost >= GlobalVars.current_money)
	
func button_pressed():
	emit_signal("build_pressed", unit_to_spawn, unit_data)

func _on_Button_mouse_entered() -> void:
	GlobalVars.mouse_hovering_ui = true

func _on_Button_mouse_exited() -> void:
	GlobalVars.mouse_hovering_ui = false
