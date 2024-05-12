extends Control

#var selected_tile = Vector2.ZERO #setget update_selected_tile

var colnames = ["A", "B", "C", "D", "E", "F"]

onready var label = $TileSelectLabel
onready var select_tilemap = $"../SelectTilemap"
onready var labelSeed = $SeedLabel
onready var treasureLabel = $TreasureLabel

var formatted_tile_label = "Z9"

signal formatted_tile_label_signal

#func update_selected_tile(tile_coords):
#	pass
	# Update this to return 'no diggable tile' if outside
	# of grid
	# need to import boundaries from elsewhere
	# Also convert columns to A, B, C, D, E

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "No Diggable Tile Selected"
	labelSeed.text = "Seed: " + str(Globals.random_seed_selected)
	treasureLabel.text = "Treasure:\n0 pieces"

func _on_SelectTilemap_current_tile_signal(tile_coords):
	if  tile_coords == Vector2.ZERO:
		label.text = "No Diggable Tile Selected"
	elif tile_coords[0] > (select_tilemap.GridXStart + select_tilemap.GridSizeX ) or tile_coords[1] > (select_tilemap.GridYStart + select_tilemap.GridSizeY ):
		label.text = "No Diggable Tile Selected"
	else:
		formatted_tile_label = str(colnames[tile_coords[0] - select_tilemap.GridXStart]) + \
							   str(tile_coords[1] - select_tilemap.GridYStart + 1)
		
		label.text = "Selected Tile = " + formatted_tile_label
		emit_signal("formatted_tile_label_signal", formatted_tile_label)

func _on_SelectTilemap_tile_in_diggable_limits(value):
	if value == false:
		label.text = "No Diggable Tile Selected"

func _on_Player_treasure_found(value):
	if value == 1:
		treasureLabel.text = "Treasure:\n" + str(value) + " piece"
	else:
		treasureLabel.text = "Treasure:\n" + str(value) + " pieces"
