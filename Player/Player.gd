extends Node2D

var allow_click = false
var tile = Vector2.ZERO

var rand_float = 0.0

onready var select_tilemap = $"../SelectTilemap"
onready var world = $".."

onready var world_array = world.world_prob_array

signal treasure_found

func _on_World_world_prob_array_created(value):
	world_array = value

func _ready():
	print(world_array)
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
			
			rand_float = randf()
			print(rand_float)
			print(world_array.get(str(tile))['Prob'])
			
			if rand_float < world_array.get(str(tile))['Prob']:
				emit_signal("treasure_found")
				world_array.get(str(tile))['Times_Success'] += 1
				world_array.get(str(tile))['Prob_Observed'] = (
					world_array.get(str(tile))['Times_Success'] / 
					world_array.get(str(tile))['Times_Dug'] )
				
		else:
			print("Can't click there, mate")

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




