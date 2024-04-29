extends Control

#var selected_tile = Vector2.ZERO #setget update_selected_tile

var colnames = ["A", "B", "C", "D", "E", "F"]

onready var label = $TileSelectLabel
onready var select_tilemap = $"../SelectTilemap"
onready var labelSeed = $SeedLabel

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

func _on_SelectTilemap_current_tile_signal(tile_coords):
	if  tile_coords == Vector2.ZERO:
		label.text = "No Diggable Tile Selected"
	elif tile_coords[0] > (select_tilemap.GridXStart + select_tilemap.GridSizeX ) or tile_coords[1] > (select_tilemap.GridYStart + select_tilemap.GridSizeY ):
		label.text = "No Diggable Tile Selected"
	else:
		label.text = "Selected Tile = " + \
		str(colnames[tile_coords[0] - select_tilemap.GridXStart]) + \
		str(tile_coords[1] - select_tilemap.GridYStart + 1)

func _on_SelectTilemap_tile_in_diggable_limits(value):
	if value == false:
		label.text = "No Diggable Tile Selected"
