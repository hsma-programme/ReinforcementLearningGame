extends Control

onready var choose_ai_mode_popup = $PopupMenuAIMode

func _ready():
	Globals.random_seed_selected = 42
	Globals.turns = 0

func _on_ManualPlayButton_pressed():
	get_tree().change_scene("Instructions.tscn")
	Globals.play_mode = "manual"
	
func _on_LineEdit_text_changed(new_text):
	Globals.random_seed_selected = new_text


func _on_AiPlayButton1_button_down():
	choose_ai_mode_popup.popup_centered()
	get_tree().paused = true
