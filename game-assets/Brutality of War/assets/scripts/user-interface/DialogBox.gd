extends Control

var fading_out : bool

func initialize(avatar, character, dialog, time):
	if avatar != null:
		$ColorRect/Contents/Avatar.texture = avatar
	if avatar == null:
		$ColorRect/Contents/Avatar.hide()
	$ColorRect/Contents/Text/Character.text = character
	$ColorRect/Contents/Text/Dialog.bbcode_text = dialog
	$DestroyTimer.wait_time = time
	
func _process(delta: float) -> void:
	if fading_out == true:
		modulate.a -= delta
	if modulate.a <= 0:
		queue_free()

func _on_DestroyTimer_timeout() -> void:
	fading_out = true
