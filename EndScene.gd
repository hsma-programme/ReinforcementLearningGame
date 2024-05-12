extends Node2D

var world_prob_array = Globals.final_world_prob_array

# https://www.reddit.com/r/godot/comments/b6wn9j/creating_a_gradient_instance_in_a_script/
var colors = Globals.colors
var colors_array = Globals.colors_array

onready var treasureLabel = $TreasureLabel

var observed_estimated_label = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.play_mode == "manual" or Globals.play_mode == "ai_simple":
		observed_estimated_label = "Observed: " 
	else:
		observed_estimated_label = "Estimated: "
	
	var step = Globals.color_step
	var idx = 0.0
	var cell_size = 52
	
	for color in colors_array:
		colors.add_point(idx, color)
		idx = min(idx + step, .999) 
		# setting a color at point 1.0 failed to add it correctly to the end of the gradient
	
	var margin_left = 0
	var margin_top = 0
	
	var new_font: DynamicFont = DynamicFont.new()
	new_font.font_data = load("res://Fonts/8-bit-operator/8bitOperatorPlus8-Regular.ttf")
	new_font.size = 6
		
	for cell in world_prob_array.keys():
		var x = ColorRect.new()
		var lab = Label.new()
		x.name = str(cell)
		margin_left = (int(cell[1])*cell_size)+32+2
		margin_top = (int(cell[4])*cell_size)+45+2
		x.rect_position = Vector2(margin_left, margin_top)
		x.rect_size = Vector2(cell_size*.95,cell_size*.95)
		lab.rect_position = Vector2(margin_left, margin_top)
		lab.rect_size = Vector2(cell_size*.9,cell_size*.9)
		if world_prob_array.get(str(cell))['Times_Dug'] == 0.0:
			lab.text = "Not\nExplored!" + "\n\nActual:" +  str(world_prob_array.get(str(cell))['Prob']) + "\n"
			x.color = Color(0, .5, 0, 0.25)
		else:
			lab.text = observed_estimated_label + str(stepify(world_prob_array.get(str(cell))['Prob_Observed'],0.01)) + "\n\nActual: " +  str(world_prob_array.get(str(cell))['Prob']) + "\n\nTimes Dug: " + str(world_prob_array.get(str(cell))['Times_Dug'])
			x.color = colors.interpolate(clamp(world_prob_array[str(cell)]['Prob_Observed'], 0.01, 0.99))
		#lab.set("theme_override_font_sizes/font_size", 8)
		#lab.add_theme_font_size_override("font_size", 8)
		lab.set("custom_fonts/font", new_font)
		lab.align = 1
		lab.valign = 1
		#lab.autowrap = true
		add_child(x)
		add_child(lab)

	# Add smaller grid showing actual probabilities
	for cell in world_prob_array.keys():
		var x = ColorRect.new()
		var lab = Label.new()
		x.name = str(cell + "_actual")
		margin_left = (int(cell[1])*16)+340+2
		margin_top = (int(cell[4])*16)+64+2
		x.rect_position = Vector2(margin_left, margin_top)
		x.rect_size = Vector2(14,14)
		x.color = colors.interpolate(clamp(world_prob_array[str(cell)]['Prob'], 0.01, 0.99))
		lab.rect_position = Vector2(margin_left-1, margin_top-1)
		lab.rect_size = Vector2(16,16)
		lab.set("custom_fonts/font", new_font)
		lab.text = str(stepify(world_prob_array.get(str(cell))['Prob'],0.01))
		lab.align = 1
		lab.valign = 1
		add_child(x)
		add_child(lab)
	
	# Add smaller grid showing observed probabilities
	for cell in world_prob_array.keys():
		var x = ColorRect.new()
		var lab = Label.new()
		x.name = str(cell + "_actual")
		margin_left = (int(cell[1])*16)+340+2
		margin_top = (int(cell[4])*16)+190+2
		x.rect_position = Vector2(margin_left, margin_top)
		x.rect_size = Vector2(14,14)
		lab.rect_position = Vector2(margin_left-1, margin_top-1)
		lab.rect_size = Vector2(16,16)
		if world_prob_array.get(str(cell))['Times_Dug'] == 0.0:
			x.color = Color(0, .5, 0, 0.25)
		else:
			x.color = colors.interpolate(clamp(world_prob_array[str(cell)]['Prob_Observed'], 0.01, 0.99))
			lab.text = str(stepify(world_prob_array.get(str(cell))['Prob_Observed'],0.01))
		lab.set("custom_fonts/font", new_font)
		lab.align = 1
		lab.valign = 1
		add_child(x)
		add_child(lab)

	treasureLabel.text += str(Globals.treasure_count) + " pieces"
	# Add variable tracking times moved and times dug (exploit/explore measure of some kind)
