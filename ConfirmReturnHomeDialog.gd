extends ConfirmationDialog

func _on_ConfirmReturnHomeDialog_confirmed():
	get_tree().paused = false
	Globals.turns = 0
	Globals.treasure_count = 0
	Globals.play_mode = "none"
	
	get_tree().change_scene("TitleScene.tscn")
	
func _on_ConfirmReturnHomeDialog_popup_hide():
	get_tree().paused = false
