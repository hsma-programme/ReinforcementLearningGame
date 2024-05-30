extends Node2D

onready var checkbox = $CheckBox

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.play_mode != "manual":
		$ExploitationRate.value = Globals.agent_exploitation_rate
		$PlaySpeed.value = Globals.play_speed
		$LearningRate.value = Globals.agent_learning_rate
	 
	if Globals.debug_mode == true:
		checkbox.pressed = true
	else:
		checkbox.pressed = false

func _on_Button_button_down():
	get_tree().change_scene("World.tscn")

func _on_ExploitationRate_value_changed(value):
	Globals.agent_exploitation_rate = value

func _on_LearningRate_value_changed(value):
	Globals.agent_learning_rate = value

func _on_PlaySpeed_value_changed(value):
	Globals.play_speed = value

func _on_CheckBox_toggled(button_pressed):
	if button_pressed == false:
		Globals.debug_mode = false
		print(Globals.debug_mode)
	else: 
		Globals.debug_mode = true
		print(Globals.debug_mode)
	
