##extends Node
#extends TileMap
#
#var treasure_data = {}
#
#class DiggableTile:
#	var treasure_prob = 0.0
#
#
#func _ready():
#	for tile in get_used_cells_by_id(0):
#			growth_data[tile] = FruitPatch.new()
#	for tile in get_used_cells_by_id(1):
#		growth_data[tile] = VeggiePatch.new()
#
#func do_stuff_to_tile(tile_pos):
#	var tile_growth_data = growth_data[tile_pos]
#	# Do stuff to tile_growth_data here
