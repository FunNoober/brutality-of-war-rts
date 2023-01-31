extends TextureRect

export var mod_name : String
export var texture_name : String

onready var extension = GlobalVars.mod_extension

func _ready() -> void:
	var f = File.new()
	if f.file_exists("user://" + texture_name):
		var img_tex = ImageTexture.new()
		img_tex.load("user://" + texture_name)
		texture = img_tex
