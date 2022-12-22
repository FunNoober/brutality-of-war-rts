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

func _on_InfinteMoneyBox_toggled(button_pressed: bool) -> void:
	GlobalVars.infinite_money = button_pressed

func _on_InstantBuildBox_toggled(button_pressed: bool) -> void:
	GlobalVars.instant_build = button_pressed
	
func _on_FactionSelectOption_item_selected(index: int) -> void:
	if index == 0:
		GlobalVars.player_faction = 0
	elif index == 1:
		GlobalVars.player_faction = 1

