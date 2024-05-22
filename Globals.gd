extends Node

var random_seed_selected = 42
var turns = 0
var max_turns = 200
var treasure_count = 0

var play_mode = "none"

var agent_exploitation_rate = 0.9

# the beta parameter for the linear operator learning rule - how much emphasis
# will be put on the new sample vs the historic estimate of this cell.
# learning rate = 1 would lead to only the newest sample being used (so
# everything would be estimated as either perfect or empty)
# learning rate = 0 would never take any notice of new samples, and never
# change estimates.  learning rates in between would gradually place more
# emphasis on the latest experience (a faster learning rate) as tending
# towards 1
var agent_learning_rate = 0.1 # default = 0.3

var GridXStart = 2
var GridYStart = 2
var GridSizeX = 5
var GridSizeY = 5

var can_click = true

var colors = Gradient.new()
var colors_array = [Color(0, 0, .9, 0.3), Color(.5, 0, 0, 0.6), Color(.9, 0, 0, 0.8)]
var color_step = 1.0 / (len(colors_array) - 1)

var initial_world_prob_array = {}

var final_world_prob_array = {}

var play_speed = 1

func get_wait(play_speed):
	var ai_wait_duration = 0.0
	
	if play_speed == 1:
		ai_wait_duration = 2.8
	elif play_speed == 2:
		ai_wait_duration = 1.8
	elif play_speed == 3:
		ai_wait_duration = 1.0
	elif play_speed == 4:
		ai_wait_duration = 0.5	
	elif play_speed == 5:
		ai_wait_duration = 0.05
	return ai_wait_duration


