extends Button

export var map_data : Resource

func _on_Button_pressed() -> void:
	GlobalVars.map_data = map_data
	get_tree().change_scene_to(load("res://scenes/LevelSelectMenu/LevelMenu.tscn"))
