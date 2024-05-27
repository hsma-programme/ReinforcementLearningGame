extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.play_mode != "manual":
		$ExploitationRate.value = Globals.agent_exploitation_rate
		$PlaySpeed.value = Globals.play_speed
		$LearningRate.value = Globals.agent_learning_rate

func _on_Button_button_down():
	get_tree().change_scene("World.tscn")

func _on_ExploitationRate_value_changed(value):
	Globals.agent_exploitation_rate = value

func _on_LearningRate_value_changed(value):
	Globals.agent_learning_rate = value

func _on_PlaySpeed_value_changed(value):
	Globals.play_speed = value
