extends ConfirmationDialog

func _on_ConfirmReturnHomeDialog_confirmed():
	get_tree().paused = false
	get_tree().change_scene("TitleScene.tscn")


func _on_ConfirmReturnHomeDialog_popup_hide():
	get_tree().paused = false
