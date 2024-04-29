extends Control

var selected_tile = Vector2.ZERO #setget update_selected_tile

onready var label = $TileSelectLabel

#func update_selected_tile(tile_coords):
#	pass
	# Update this to return 'no diggable tile' if outside
	# of grid
	# need to import boundaries from elsewhere
	# Also convert columns to A, B, C, D, E

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "No Diggable Tile Selected"

func _on_SelectTilemap_current_tile_signal(tile_coords):
	if  tile_coords == Vector2.ZERO:
		label.text = "No Diggable Tile Selected"
	else:
		label.text = "Selected Tile = " + str( tile_coords)

func _on_SelectTilemap_tile_in_diggable_limits(value):
	if value == false:
		label.text = "No Diggable Tile Selected"
