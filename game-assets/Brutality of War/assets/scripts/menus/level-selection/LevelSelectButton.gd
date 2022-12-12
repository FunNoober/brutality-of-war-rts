extends Button

export var map_data : Resource

func _ready() -> void:
	connect("mouse_entered", self, "mouse_entered")
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load("res://assets/sounds/ui/ui_hover_001.ogg")
	sound_player.bus = "UI Sound"
	sound_player.name = "AudioStreamPlayer"
	add_child(sound_player)

func _on_Button_pressed() -> void:
	GlobalVars.map_data = map_data
	get_tree().change_scene_to(load("res://scenes/LevelSelectMenu/LevelMenu.tscn"))

func mouse_entered():
	$AudioStreamPlayer.play()
