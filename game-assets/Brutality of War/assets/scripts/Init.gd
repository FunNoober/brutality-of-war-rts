extends Control

export(String, MULTILINE) var modding_guide

func _ready() -> void:
	var f = File.new()
	f.open("user://MODDING_DOCUMENTATION.txt", f.WRITE)
	f.store_string(modding_guide)
	f.close()
