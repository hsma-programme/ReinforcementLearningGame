extends Control

func _ready():
	Globals.random_seed_selected = 42
	Globals.turns = 0

func _on_ManualPlayButton_pressed():
	get_tree().change_scene("World.tscn")


func _on_LineEdit_text_changed(new_text):
	Globals.random_seed_selected = new_text
