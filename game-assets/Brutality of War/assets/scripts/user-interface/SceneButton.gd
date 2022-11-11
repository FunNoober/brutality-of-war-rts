extends Button

class_name Scene_Button

export var scene : PackedScene

func _ready() -> void:
	connect("pressed", self, "on_button_pressed")

func on_button_pressed():
	get_tree().change_scene_to(scene)
