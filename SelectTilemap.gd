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
	print(tile)
	
	# First turn off the TileSelect for all 
	for x in range(GridXStart, GridXStart + GridSizeX, 1):
		for y in range(GridYStart, GridYStart + GridSizeY, 1):
			set_cell(x, y, 0)
	
	#for x in range(GridXStart, GridXStart + GridSizeX, 1):
	#	for y in range(GridYStart, GridYStart + GridSizeY, 1):
	if TileRangeDic.has(str(tile)):
		set_cell(tile[0], tile[1], 1)
