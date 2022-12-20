extends Button

export var unit_to_spawn : PackedScene
export var unit_data : Resource

signal build_pressed(to_spawn, u_data)

func _ready() -> void:
	connect("pressed", self, "button_pressed")
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load("res://assets/sounds/ui/ui_hover_002.ogg")
	sound_player.bus = "UI Sound"
	sound_player.name = "AudioStreamPlayer"
	add_child(sound_player)
	
func _process(delta: float) -> void:
	disabled = (unit_data.cost >= GlobalVars.current_money)
	
func button_pressed():
	emit_signal("build_pressed", unit_to_spawn, unit_data)

func _on_Button_mouse_entered() -> void:
	GlobalVars.mouse_hovering_ui = true
	$AudioStreamPlayer.play()

func _on_Button_mouse_exited() -> void:
	GlobalVars.mouse_hovering_ui = false
