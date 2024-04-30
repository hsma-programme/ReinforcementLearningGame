extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var selectTilemap = $SelectTilemap
var world_prob_array = {} 

signal world_prob_array_created

# Called when the node enters the scene tree for the first time.
func _ready():
	world_prob_array = SetupTileProbabilities.create_probability_array(
		Globals.random_seed_selected,
		selectTilemap.GridSizeX,
		selectTilemap.GridSizeY
	)
	print(world_prob_array)

	emit_signal("world_prob_array_created", world_prob_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

