extends Control

onready var turns_taken = Globals.turns #setget set_turns_ui

onready var turnUIBar = $TurnUIBar
onready var turnLabel = $TurnLabel

#func set_turns_ui(value):

func _ready():
	self.turns_taken = 0
	turnLabel.text = "Turns: 0 / " + str(Globals.max_turns)
	turnUIBar.rect_size.x = 0

func _on_Player_turn_taken(value):
	#print("Turn taken")
		# never less than 0 or greater than turns
	turns_taken = clamp(value, 0, Globals.max_turns)
	#if label != null:
	#	label.text = "HP = " + str(hearts)
	if turnUIBar != null:
		# 88.0 just seems to roughly work for current size of turn bar
		# using rect_size.x of turn bar base leads to incorrect behaviour
		turnUIBar.rect_size.x = (88.0 / Globals.max_turns) * turns_taken
		#print(turnUIBar.rect_size.x)
	
	turnLabel.text = "Turns: " + str(turns_taken) + " / " + str(Globals.max_turns)
