extends TileMap

var GridXStart = Globals.GridXStart
var GridYStart = Globals.GridYStart
var GridSizeX = Globals.GridSizeX
var GridSizeY = Globals.GridSizeY

var TileRangeDic = {}

signal current_tile_signal(current_tile)
signal tile_in_diggable_limits(value)

var current_tile = Vector2.ZERO setget update_selected_tile

func update_selected_tile(value):
	emit_signal("current_tile_signal", value)
	#print("Current Tile Updated to " + str(value))

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(GridXStart, GridXStart + GridSizeX, 1):
		for y in range(GridYStart, GridYStart + GridSizeY, 1):
			TileRangeDic[str(Vector2(x, y))] = {
				"Type": "Diggable"
			}
			set_cell(x, y , 0)
	print(TileRangeDic)

func _process(delta):
	# Don't really understand why I can't just set the first line
	# to self.current_tile, but if I do, the label works but the 
	# highlighting of the selected tile stops working
	# TODO: I feel like this is still firing the setter function
	# more frequently than expected
	current_tile = world_to_map(get_global_mouse_position())
	self.current_tile = current_tile
	
	#print(current_tile)
	# First turn off the TileSelect tile layer for all 
	for x in range(GridXStart, GridXStart + GridSizeX, 1):
		for y in range(GridYStart, GridYStart + GridSizeY, 1):
			set_cell(x, y, 0)
	
	# Now check whether current tile is in the dict we 
	# set up at the beginning (so we don't set it for any old 
	# tile on the map
	# If it is in the range of diggable tiles, then set the
	# TileSelect outline to visible 
	if Globals.can_click: 
		if TileRangeDic.has(str(current_tile)):
			emit_signal("tile_in_diggable_limits", true)
			set_cell(current_tile[0], current_tile[1], 1)
		else:
			emit_signal("tile_in_diggable_limits", false)

