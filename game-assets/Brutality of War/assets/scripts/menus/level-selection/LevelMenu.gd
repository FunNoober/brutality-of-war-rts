extends Control

var d

func _ready() -> void:
	GlobalVars.is_playing = false
	d = GlobalVars.map_data
	set_data()

func set_data():
	$VBoxContainer/MapTitleLabel.text = d.map_name
	$VBoxContainer/MapDescriptionLabel.text = d.map_description

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to(d.map)
