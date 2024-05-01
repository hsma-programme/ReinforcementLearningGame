extends Node2D

var allow_click = false
var tile = Vector2.ZERO

var rand_float = 0.0

onready var select_tilemap = $"../SelectTilemap"
onready var world = $".."

onready var world_array = world.world_prob_array
onready var text_log = $"../LabelControl/Log"

var formatted_tile_label = "Z9"

signal treasure_found
signal turn_taken

func _on_World_world_prob_array_created(value):
	world_array = value

func _on_LabelControl_formatted_tile_label_signal(value):
	formatted_tile_label = value

func _ready():
	print(world_array)
	#text_log.add_color_override("font_color_selected", Color(0,0,0,0))
	#var current_seed = Globals.random_seed_selected
	#rng.seed = hash(str(current_seed))

# Turn-taking logic
func _input(event):		
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		if allow_click == true:
			print("Clicked " + str(tile))
			#print(world_array)
			print(world_array.get(str(tile)))
			world_array.get(str(tile))['Times_Dug'] += 1
			Globals.turns += 1
			emit_signal("turn_taken", Globals.turns)
			
			# At the moment the sampling here doesn't use a random
			# number generator with a seed set - I'm not sure how to pass
			# in a rng from elsewhere, but can't set it up within the 
			# input (with seed set) else we just get the same answer each time
			# Is it worth seeding with the turn number for reproducibility?
			# Or seed * turn number for some variation across seeds, at least?
			rand_float = randf()
			print(rand_float)
			print(world_array.get(str(tile))['Prob'])
			
			if rand_float < world_array.get(str(tile))['Prob']:
				text_log.text = "Turn " + str(Globals.turns) + ": Found treasure in tile " +  str(formatted_tile_label) + "\n" +  text_log.text
				Globals.treasure_count += 1
				emit_signal("treasure_found", Globals.treasure_count)
				world_array.get(str(tile))['Times_Success'] += 1
				world_array.get(str(tile))['Prob_Observed'] = (
					world_array.get(str(tile))['Times_Success'] / 
					world_array.get(str(tile))['Times_Dug'] )
			else:
				text_log.text = "Turn " + str(Globals.turns) + ": Didn't find treasure in tile " +  str(formatted_tile_label) + "\n" +  text_log.text
				
		else:
			print("Can't click there, mate")
			text_log.text = "Invalid digging location selected - select a tile on the island" + "\n" +  text_log.text

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







