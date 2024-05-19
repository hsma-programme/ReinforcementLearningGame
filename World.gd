extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var selectTilemap = $SelectTilemap
var world_prob_array = {} 

onready var gradientScaleRect = $ScaleGradientRect

# https://www.reddit.com/r/godot/comments/telp85/how_to_create_a_gradient_via_script/
#var gradient_data := {
#    0.0: Color.red,
#    0.5: Color.green,
#    0.75: Color.violet,
#    1.0: Color.blue,
#}




# https://www.reddit.com/r/godot/comments/b6wn9j/creating_a_gradient_instance_in_a_script/
# Set grid colors based on observed probability
var colors = Globals.colors
# and the colors need to have values from 0 to 1.0
var colors_array = Globals.colors_array
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
	Globals.initial_world_prob_array = world_prob_array
	
	var idx = 0.0
	var step = Globals.color_step
	
	for color in colors_array:
		colors.add_point(idx, color)
		idx = min(idx + step, .999) 
		# setting a color at point 1.0 failed to add it correctly to the end of the gradient
		
	var gradient_texture = GradientTexture.new()
	gradient_texture.gradient = colors
	gradient_texture.width = 200
	
	gradientScaleRect.texture = gradient_texture
	
	var margin_left = 0
	var margin_top = 0
	
	for cell in world_prob_array.keys():
		var x = ColorRect.new()
		x.name = str(cell)
		margin_left = (int(cell[1])*32)+64+2
		margin_top = (int(cell[4])*32)+64+ 2
		x.rect_position = Vector2(margin_left, margin_top)
		#var check = cell + str(x.margin_left) + str(x.margin_top)
		#print(check)
#		var x = Shape2D.new()
		#x.set_custom_minimum_size(Vector2(32,32))
		#print(
		x.rect_size = Vector2(28,28)
		#print(x.rect_size)
		#x.rect_position = Vector2(cell[0], cell[1])
#		print(cell + str(x.rect_position))
		
		#x.color = colors.interpolate(world_prob_array[cell]['Prob_Observed'])
		#x.color = colors.interpolate(randf())
		
		# Set initial colour
		x.color = Color(0, .5, 0, 0.25)
		
		print(world_prob_array[cell]['Prob_Observed'])
		print(x.color)
		#box.set_frame_color(box_color)
		#x.color = Color(1,0,0,1)
		# Add node to world
		add_child(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_probabilities_updated(tile):
	#print(get_tree().get_root())
	#print(get_tree().get_root().get_node("./" + str(tile)))
	var rect_tile = get_node("./" + str(tile))
	rect_tile.color = colors.interpolate(clamp(world_prob_array[str(tile)]['Prob_Observed'], 0.01, 0.99))
	#print(self.get_child(str(tile)))
	#pass
	#print(self.get_children().get_node(str(tile)))
#	for _i in self.get_children ():
#		print(_i)
	#var rect_tile = get_tree().get_root().get_node(str(tile))
	#rect_tile.color = colors.interpolate(world_prob_array[tile]['Prob_Observed'])
	#print(rect_tile.color)


func _on_DebugButton_button_down():
	Globals.turns = 199
