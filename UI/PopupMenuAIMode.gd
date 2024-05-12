extends PopupMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_SimpleAIButton_button_down():
	print("Simple AI button pressed")
	get_tree().change_scene("World.tscn")
	Globals.play_mode = "ai_simple"
	get_tree().paused = false

func _on_AdvancedAIButton_button_down():
	print("Complex AI button pressed")
	get_tree().change_scene("World.tscn")
	Globals.play_mode = "ai_advanced"
	get_tree().paused = false

func _on_CancelButton_button_down():
	print("Cancel button pressed")
	self.hide()
	get_tree().paused = false
