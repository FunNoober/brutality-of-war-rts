extends ModdableButton

export var building_blueprint : PackedScene
export var building_data : Resource

func _ready() -> void:
	
	connect("pressed", self, "_on_BuildButton_pressed")
	connect("mouse_entered", self, "mouse_entered")
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load("res://assets/sounds/ui/ui_hover_002.ogg")
	sound_player.bus = "UI Sound"
	sound_player.name = "AudioStreamPlayer"
	add_child(sound_player)

func _process(delta: float) -> void:
	disabled = (building_data.cost >= GlobalVars.current_money)

func _on_BuildButton_pressed() -> void:
	var bb = building_blueprint.instance()
	get_node(GlobalVars.active_scene).add_child(bb)
	GlobalVars.cur_state = GlobalVars.STATES.build_mode
	get_node("../../../../").selected = false

func mouse_entered():
	$AudioStreamPlayer.play()
