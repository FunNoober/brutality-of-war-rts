extends Button

export var unit_to_spawn : PackedScene
export var unit_data : Resource

signal build_pressed(to_spawn, u_data)

func _ready() -> void:
	connect("pressed", self, "button_pressed")
	
func button_pressed():
	emit_signal("build_pressed", unit_to_spawn, unit_data)
