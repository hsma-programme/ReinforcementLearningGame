extends Node

var random_seed_selected = 42
var turns = 0
var max_turns = 200
var treasure_count = 0

var play_mode = "none"

var agent_exploitation_rate = 0.81
var learning_rate = 0.1

var GridXStart = 2
var GridYStart = 2
var GridSizeX = 5
var GridSizeY = 5

var colors = Gradient.new()
var colors_array = [Color(0, 0, .9, 0.3), Color(.5, 0, 0, 0.6), Color(.9, 0, 0, 0.8)]
var color_step = 1.0 / (len(colors_array) - 1)

var final_world_prob_array = {}
