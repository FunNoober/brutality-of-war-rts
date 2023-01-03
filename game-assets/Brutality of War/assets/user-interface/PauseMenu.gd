extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if is_visible_in_tree() == true:
			hide()
			Engine.time_scale = 1
		elif is_visible_in_tree() == false:
			show()
			Engine.time_scale = 0

func _on_ResumeButton_pressed() -> void:
	hide()
	Engine.time_scale = 1

func _on_MainMenuButton_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
