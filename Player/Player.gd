extends Node2D

var allow_click = false
var tile = Vector2.ZERO

var tile_str = ""

var outcome_var = false

var rand_float = 0.0

onready var select_tilemap = $"../SelectTilemap"
onready var world = $".."

onready var world_array = world.world_prob_array
onready var text_log = $"../LabelControl/Log"

onready var ai_wait_length = Globals.get_wait(Globals.play_speed)
onready var ai_move_cooldown_timer = $AiMoveCooldownTimer

onready var click_cooldown_timer = $ClickCooldownTimer

var ai_can_move = true

onready var sprite = $RobotSprite

var colnames = ["A", "B", "C", "D", "E", "F"]
var formatted_tile_label = "Z9"

var tile_vec = Vector2.ZERO

var chosen_tile_click = Vector2.ZERO
var previous_tile = Vector2.ZERO

var state = "idle"

var velocity = Vector2.ZERO
var destination = Vector2.ZERO



signal treasure_found
signal turn_taken
signal probabilities_updated
signal ai_selected_tile
signal exploit_explore

var found_popup_scene = preload("res://Popups/YouFoundPopup.tscn")

func _on_ReturnToHomeButton_button_down():
	sprite.play("Idle")

func _on_LabelControl_formatted_tile_label_signal(value):
	formatted_tile_label = value

func _on_SelectTilemap_current_tile_signal(current_tile):
	tile = Vector2(
		current_tile[0]-select_tilemap.GridXStart, 
		current_tile[1]-select_tilemap.GridYStart
		)

func _on_SelectTilemap_tile_in_diggable_limits(value):
	if value == false:
		allow_click = false
	else:
		allow_click = true
var t = 0.0

func run_move_animation():
	
	#state = "move"
	chosen_tile_click = tile
	#sprite.play("Walk")
	#yield(get_tree().create_timer(ai_wait_length), "timeout")
	#state = "idle"
	#sprite.play("Idle")

func _ready():
	sprite.visible = false
	
	print(world_array)
	var youfound_popup = found_popup_scene.instance()
	add_child(youfound_popup)
	

	
	print("Wait length: " + str(ai_wait_length))
	ai_move_cooldown_timer.wait_time = ai_wait_length
	
	#text_log.add_color_override("font_color_selected", Color(0,0,0,0))
	#var current_seed = Globals.random_seed_selected
	#rng.seed = hash(str(current_seed))
	# Update this after 

	

func _process(delta):
	var movement_speed_multiplier = 1
	
	if Globals.play_mode == "manual":
		movement_speed_multiplier = 1
	else:
		movement_speed_multiplier = Globals.play_speed
	#t += delta * 0.4
	#if state == "move":
	destination = Vector2(int(chosen_tile_click[0])*32 + Globals.GridXStart*32, int(chosen_tile_click[1])*32 + Globals.GridYStart*32)
	
	#print(sprite.position.distance_to(destination))
	
	if sprite.position.distance_to(destination) > 2 : 
		sprite.play("Walk")
		sprite.position = sprite.position.linear_interpolate(destination, delta*3.0 *float(movement_speed_multiplier))
		#state = "move"
		#print(sprite.position)
		#print(chosen_tile_click)
		#print("position:" + str(sprite.position))
		#print("destination:" + str(destination))
		if destination < sprite.position:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		#state == "idle"
		sprite.play("Idle")

func _on_Timer_timeout():
	Globals.can_click = true

func format_tile_label(tile_coords):
	return str(colnames[tile_coords[0]]) + \
				str(tile_coords[1] + 1)

func first_turn_msg(tile=Vector2.ZERO):
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		formatted_tile_label = format_tile_label(tile)
	run_move_animation()
	text_log.text = "Turn " + str(Globals.turns) + ": The helicopter has dropped you off in tile " + str(formatted_tile_label) + " . Starting to dig..."  + "\n" +  text_log.text
	Globals.turns += 1
	Globals.times_dug += 1
	sprite.visible = true

func dug_again_same_tile_msg(tile=Vector2.ZERO):
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		formatted_tile_label = format_tile_label(tile)
	text_log.text = "Turn " + str(Globals.turns) + ": Dug in tile " + str(formatted_tile_label) + " again"  + "\n" +  text_log.text
	Globals.turns += 1
	Globals.times_dug += 1

func penultimate_turn_invalid_selection_msg():
	text_log.text = "Can't move on penultimate turn - digging in same tile again instead."
	tile = previous_tile
	Globals.turns += 1
	Globals.times_dug += 1
	
func move_tile_and_dig_msg(tile=Vector2.ZERO):
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		formatted_tile_label = format_tile_label(tile)
	
	text_log.text = "Turn " + str(Globals.turns) + ": Moved to new tile " + str(formatted_tile_label) + "\n" +  text_log.text
	Globals.turns += 1	
	Globals.times_moved += 1
	run_move_animation()
	text_log.text = "Turn " + str(Globals.turns) + ": Dug in tile " + str(formatted_tile_label) + "\n" +  text_log.text
	Globals.turns += 1
	Globals.times_dug += 1

func treasure_found_popup(popup_label, popup, popup_timer):
	popup_label.text = "You found treasure!"
	#popup.show()
	popup.popup()
	popup_timer.start()
	#get_tree().paused = true

func on_treasure_found(popup_label="", popup="", popup_timer="", tile=Vector2.ZERO):
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		formatted_tile_label = format_tile_label(tile)
	text_log.text = "Turn " + str(Globals.turns) + ": Found treasure in tile " +  str(formatted_tile_label) + "\n" +  text_log.text
	Globals.treasure_count += 1
	emit_signal("treasure_found", Globals.treasure_count)
	world_array.get(str(tile))['Times_Success'] += 1
	if Globals.play_mode == "manual":
		treasure_found_popup(popup_label, popup, popup_timer)
	
func on_treasure_not_found(tile=Vector2.ZERO):
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		formatted_tile_label = format_tile_label(tile)
	text_log.text = "Turn " + str(Globals.turns) + ": Didn't find treasure in tile " +  str(formatted_tile_label) + "\n" +  text_log.text

func update_probabilities():
	world_array.get(str(tile))['Prob_Observed'] = (
				world_array.get(str(tile))['Times_Success'] / 
				world_array.get(str(tile))['Times_Dug'] 
			)
	emit_signal("probabilities_updated", tile)
	
func update_probabilities_simple_ai():
	
	world_array.get(str(tile))['Prob_Estimate'] = (
				world_array.get(str(tile))['Times_Success'] / 
				world_array.get(str(tile))['Times_Dug'] 
			)
			
	world_array.get(str(tile))['Prob_Observed'] = world_array.get(str(tile))['Prob_Estimate']
	
	emit_signal("probabilities_updated", tile)

func update_probabilities_with_lr():
	var prev_estimate = world_array.get(str(tile))['Prob_Estimate']
	
	world_array.get(str(tile))['Prob_Estimate'] = ((Globals.agent_learning_rate * Globals.last_found_state) +
													((1.0-Globals.agent_learning_rate) *
													 prev_estimate)
													)
	print("Updated prob calculated as " + str(Globals.agent_learning_rate) + " * " + str(Globals.last_found_state) + " + ((1 - " + str(Globals.agent_learning_rate) + ") * " + str(prev_estimate)  + ")")
	
	world_array.get(str(tile))['Prob_Observed'] = world_array.get(str(tile))['Prob_Estimate']
	
	emit_signal("probabilities_updated", tile)

func on_invalid_dig_location_clicked():
	print("Can't click there, mate")
	text_log.text = "Invalid digging location selected - select a tile on the island" + "\n" +  text_log.text

func update_after_turn():
	world_array.get(str(tile))['Times_Dug'] += 1
	emit_signal("turn_taken", Globals.turns)
	previous_tile = tile

func on_final_turn():
	Globals.final_world_prob_array = world_array
	get_tree().change_scene("EndScene.tscn")
	
func digging_outcome(popup_label="none", popup="none", popup_timer="none"):
	rand_float = randf()
				
	#print(rand_float)
	#print(world_array.get(str(tile))['Prob'])
				
	if rand_float < world_array.get(str(tile))['Prob']:
		on_treasure_found(popup_label, popup, popup_timer, tile)
		Globals.last_found_state = 1
		print("Treasure Found: Last found state set to 1")
		return true
	else:
		on_treasure_not_found(tile)
		Globals.last_found_state = 0
		print("Treasure NOT Found: Last found state set to 0")
		return false

func get_random_tile():
	var tile_x = randi() % (Globals.GridSizeX)
	var tile_y = randi() % (Globals.GridSizeY)
	print("Random Tile Selected: (" + str(tile_x) + ", " + str(tile_y) + ")")
	return Vector2(tile_x, tile_y)

func _on_World_world_prob_array_created(value):
	world_array = value
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		Globals.can_click = false
		#self.visible = false
			
		# Select a random first tile
		#if Globals.turns == 0:
		tile = get_random_tile()
		emit_signal("ai_selected_tile", tile)
		tile_str = str(tile)	
		previous_tile = tile
		
		first_turn_msg(tile)
		update_after_turn()	
		digging_outcome()
		if Globals.play_mode == "ai_simple":
			update_probabilities_simple_ai()
		else:
			update_probabilities_with_lr()
		#get_tree().paused = true
		ai_can_move = false
		ai_move_cooldown_timer.start()
		#yield(get_tree().create_timer(ai_wait_length), "timeout")
		#get_tree().paused = false

		var exploit_or_explore = 0.0
			
		while Globals.turns < Globals.max_turns:
			ai_move_cooldown_timer.start()
			yield(ai_move_cooldown_timer, "timeout")
			# Use specified logic to decide what move to make
			# Do move 
			# increment turn
			# return to start of while loop
			# Begins by random sample between 0 and 1
			# if lower than exploitation rate, will find the highest estimated location
			# simple solution for ties - just take the first in the list
			# if sample is higher than explitation rate, will choose a random 
			# location and go there
			# add a timer while the AI 'thinks', then next turn
			exploit_or_explore = randf()
			print("Sampled " + str(exploit_or_explore) + " vs exploitation rate of " + str(Globals.agent_exploitation_rate))
			

			if exploit_or_explore < Globals.agent_exploitation_rate:
				# Exploit
				emit_signal("exploit_explore", "Exploit!")
				# Find highest rate and go there
				#text_log.text = "Turn " + str(Globals.turns) + ": Exploit!\n" +  text_log.text
				#tile_select_label.visible = true
				#tile_select_label.text = "Exploit!"
				#yield(get_tree().create_timer(0.3), "timeout")
				#tile_select_label.visible = false
				
				
				
				var current_highest_cell = Vector2.ZERO
				var current_highest_prob = 0.0
				var cell_prob_observed = 0.0

				if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
					for cell in world_array.keys():				
						cell_prob_observed = world_array.get(str(cell))['Prob_Estimate']
						if cell_prob_observed > current_highest_prob:
							current_highest_cell = Vector2(cell[1], cell[4])
							current_highest_prob = cell_prob_observed
				
				#current_highest_cell = Vector2(current_highest_cell[0], current_highest_cell[1])
				
				print("Exploiting current highest cell: " + str(current_highest_cell) + " (prob " + str(current_highest_prob) + ")")
				
				tile = current_highest_cell
				emit_signal("ai_selected_tile", tile)
				
			else:
				# Explore
				# Choose random tile and go there
				emit_signal("exploit_explore", "Explore!")
				#text_log.text = "Turn " + str(Globals.turns) + ": Explore!\n" +  text_log.text
				tile = get_random_tile()
				emit_signal("ai_selected_tile", tile)
				tile_str = str(tile_vec)
			
			if Globals.turns > 0 and previous_tile == tile:
				dug_again_same_tile_msg(tile)
			elif Globals.turns == (Globals.max_turns-1) and previous_tile != tile:
				penultimate_turn_invalid_selection_msg()
			else:
				move_tile_and_dig_msg(tile)
				
			update_after_turn()	
			digging_outcome()
			
			if Globals.play_mode == "ai_simple":
				update_probabilities_simple_ai()
			else:
				update_probabilities_with_lr()
			#get_tree().paused = true
			#yield(get_tree().create_timer(ai_wait_length), "timeout")
			#get_tree().paused = false
		
		on_final_turn()
	
# Turn-taking logic for manual play
func _input(event):		
	if Globals.play_mode == "manual":
		if (event.is_pressed() and event.button_index == BUTTON_LEFT):
			if allow_click == true:
				var popup = get_node("./Popup")
				var popup_label = get_node("./Popup/YouFoundLabel")
				var popup_timer = get_node("./Popup/DismissAutoTimer")
				print("Clicked " + str(tile))
				#print(world_array)
				#print(world_array.get(str(tile)))
				
				if Globals.can_click:

					if Globals.turns == 0:
						first_turn_msg()
					elif Globals.turns > 0 and previous_tile == tile:
						dug_again_same_tile_msg()
					elif Globals.turns == (Globals.max_turns-1) and previous_tile != tile:
						penultimate_turn_invalid_selection_msg()
					else:
						move_tile_and_dig_msg()
					
					Globals.can_click = false
					
					update_after_turn()	

					# At the moment the sampling here doesn't use a random
					# number generator with a seed set - I'm not sure how to pass
					# in a rng from elsewhere, but can't set it up within the 
					# input (with seed set) else we just get the same answer each time
					# Is it worth seeding with the turn number for reproducibility?
					# Or seed * turn number for some variation across seeds, at least?
					
					outcome_var = digging_outcome(popup_label, popup, popup_timer)
					
					if previous_tile == tile and outcome_var:
						click_cooldown_timer.wait_time = popup_timer.wait_time
					elif previous_tile == tile:
						click_cooldown_timer.wait_time = 0.1
					else:
						click_cooldown_timer.wait_time = 1.5
					click_cooldown_timer.start()
					
					update_probabilities()					
					
			else:
				on_invalid_dig_location_clicked()
				
			
			if Globals.turns == Globals.max_turns:
				on_final_turn()
	
			
		

func _on_ClickCooldownTimer_timeout():
	Globals.can_click = true


func _on_AiMoveCooldownTimer_timeout():
	ai_can_move = true
