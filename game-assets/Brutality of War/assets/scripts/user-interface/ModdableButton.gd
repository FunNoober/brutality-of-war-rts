extends Button
class_name ModdableButton

export var mod_name : String
export var icon_name : String
export var use_icon : bool
export var use_mod : bool = true

onready var extension = GlobalVars.mod_extension

var moddable_data = {
	"text" : text
}

func _ready() -> void:
	var f = File.new()
	if f.file_exists("user://" + mod_name + "_b" + extension):
		f.open("user://" + mod_name + "_b" + extension, f.READ)
		var contents_as_dictionary = parse_json(f.get_as_text())
		text = contents_as_dictionary.text
		
		if f.file_exists("user://" + icon_name) and use_icon:
			var img_tex = ImageTexture.new()
			img_tex.load("user://" + icon_name)
			icon = img_tex
	else:
		f.open("user://" + mod_name + "_b" + extension, f.WRITE)
		f.store_string(JSON.print(moddable_data))
		f.close()
