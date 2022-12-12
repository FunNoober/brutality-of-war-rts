extends Button

class_name Scene_Button

export var scene : PackedScene

func _ready() -> void:
	connect("pressed", self, "on_button_pressed")
	connect("mouse_entered", self, "mouse_entered")
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load("res://assets/sounds/ui/ui_hover_001.ogg")
	sound_player.bus = "UI Sound"
	sound_player.name = "AudioStreamPlayer"
	add_child(sound_player)

func on_button_pressed():
	get_tree().change_scene_to(scene)

func mouse_entered():
	$AudioStreamPlayer.play()
