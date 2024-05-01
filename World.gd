extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var selectTilemap = $SelectTilemap
var world_prob_array = {} 

# https://www.reddit.com/r/godot/comments/b6wn9j/creating_a_gradient_instance_in_a_script/
# Set grid colors based on observed probability
var colors = Gradient.new()
# and the colors need to have values from 0 to 1.0
var colors_array = [Color(.01, 0, 0, 0.4), Color(.5, 0, 0, 0.4), Color(.9, 0, 0, 0.4)]
#var box_size = Vector2(1,1)
#onready var box = get_node("ColorRect")

signal world_prob_array_created

# Called when the node enters the scene tree for the first time.
func _ready():
	world_prob_array = SetupTileProbabilities.create_probability_array(
		Globals.random_seed_selected,
		selectTilemap.GridSizeX,
		selectTilemap.GridSizeY
	)
	#print(world_prob_array)

	emit_signal("world_prob_array_created", world_prob_array)
	
	var idx = 0.0
	
	var step = 1.0 / (len(colors_array) - 1)
	
	for color in colors_array:
		colors.add_point(idx, color)
		idx = min(idx + step, .999) 
		# setting a color at point 1.0 failed to add it correctly to the end of the gradient
		#box_size = box.get_size()
	
	var margin_left = 0
	var margin_top = 0
	
	for cell in world_prob_array.keys():
		var x = ColorRect.new()
		x.name = str(cell)
		margin_left = (int(cell[1])*32)+64+2
		margin_top = (int(cell[4])*32)+64+ 2
		x.rect_position = Vector2(margin_left, margin_top)
		var check = cell + str(x.margin_left) + str(x.margin_top)
		print(check)
#		var x = Shape2D.new()
		#x.set_custom_minimum_size(Vector2(32,32))
		#print(
		x.rect_size = Vector2(28,28)
		#print(x.rect_size)
		#x.rect_position = Vector2(cell[0], cell[1])
#		print(cell + str(x.rect_position))
		
		#x.color = colors.interpolate(world_prob_array[cell]['Prob_Observed'])
		x.color = colors.interpolate(randf())
		
		print(world_prob_array[cell]['Prob_Observed'])
		print(x.color)
		#box.set_frame_color(box_color)
		#x.color = Color(1,0,0,1)
		add_child(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_probabilities_updated(tile):
	#print(self.get_child(str(tile)))
	pass
	#print(self.get_children().get_node(str(tile)))
#	for _i in self.get_children ():
#		print(_i)
	#var rect_tile = get_tree().get_root().get_node(str(tile))
	#rect_tile.color = colors.interpolate(world_prob_array[tile]['Prob_Observed'])
	#print(rect_tile.color)
