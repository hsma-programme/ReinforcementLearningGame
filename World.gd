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

var observed_estimated_label = ""


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
	
	Globals.initial_world_prob_array = world_prob_array
	
	if Globals.play_mode == "ai_simple" or Globals.play_mode == "ai_advanced":
		$LabelControl/TileSelectLabel.visible = false
	
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
	gradientScaleRect.modulate = Color(0.8, 1.0, 0.8, 0.85)
	
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
	emit_signal("world_prob_array_created", world_prob_array)

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
	if Globals.debug_mode:
		if Globals.play_mode == "manual":
			observed_estimated_label = "O: " 
		else:
			observed_estimated_label = "E: "
		
		#var step = Globals.color_step
		#var idx = 0.0
		var cell_size = 32
		
		#for color in colors_array:
		#	colors.add_point(idx, color)
	#		idx = min(idx + step, .999) 
			# setting a color at point 1.0 failed to add it correctly to the end of the gradient
		
		var margin_left = 0
		var margin_top = 0
		
		var new_font: DynamicFont = DynamicFont.new()
		new_font.font_data = load("res://Fonts/8-bit-operator/8bitOperatorPlus8-Regular.ttf")
		new_font.size = 6
		
		
		
		#self.get_children().queue_free()
			
		for cell in world_prob_array.keys():
			
			var existing = get_tree().get_root().find_node("*X*"+(str(cell))+"*", true, false)
			
			var lab = Label.new()
			
			if existing != null:
				#print("Existing" + existing.name)
				#print(existing)
				#existing.remove_node()
				#existing.queue_free()
				lab = existing
			
			#var x = ColorRect.new()

			#x.name = str(cell)
			margin_left = (int(cell[1])*cell_size)+64+2
			margin_top = (int(cell[4])*cell_size)+64+2
			#x.rect_position = Vector2(margin_left, margin_top)
			#x.rect_size = Vector2(cell_size*.95,cell_size*.95)
			lab.rect_position = Vector2(margin_left, margin_top)
			lab.rect_size = Vector2(cell_size*.9,cell_size*.9)
			if world_prob_array.get(str(cell))['Times_Dug'] == 0.0:
				if Globals.play_mode == "manual":
					lab.text ="\n\nA:" +  str(world_prob_array.get(str(cell))['Prob']) + "\n"
					#x.color = Color(0, 0, 0, 0.001)
				else:
					lab.text = observed_estimated_label + str(stepify(world_prob_array.get(str(cell))['Prob_Estimate'],0.01)) + "\n\nA:" +  str(world_prob_array.get(str(cell))['Prob'])
					#x.color = Color(0, 0, 0, 0.001)
			else:
				lab.text = observed_estimated_label + str(stepify(world_prob_array.get(str(cell))['Prob_Observed'],0.01)) + "\n\nA: " +  str(world_prob_array.get(str(cell))['Prob'])
				#x.color = Color(0, 0, 0, 0.001)
			#lab.set("theme_override_font_sizes/font_size", 8)
			#lab.add_theme_font_size_override("font_size", 8)
			lab.set("custom_fonts/font", new_font)
			lab.align = 1
			lab.valign = 1
			#lab.autowrap = true
			#add_child(x)
			lab.name = "X" + str(cell)
			add_child(lab)
			#move_child(lab, 0)


func _on_DebugButton_button_down():
	Globals.turns = 199
