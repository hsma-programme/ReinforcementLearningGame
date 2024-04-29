extends TileMap

var GridXStart = 2
var GridYStart = 2
var GridSizeX = 5
var GridSizeY = 5
var TileRangeDic = {}

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
	var tile = world_to_map(get_global_mouse_position())
	#print(tile)
	
	# First turn off the TileSelect tile layer for all 
	for x in range(GridXStart, GridXStart + GridSizeX, 1):
		for y in range(GridYStart, GridYStart + GridSizeY, 1):
			set_cell(x, y, 0)
	
	# Now check whether current tile is in the dict we 
	# set up at the beginning (so we don't set it for any old 
	# tile on the map
	# If it is in the range of diggable tiles, then set the
	# TileSelect outline to visible 
	if TileRangeDic.has(str(tile)):
		set_cell(tile[0], tile[1], 1)
