extends Node2D

var world_prob_array = Globals.final_world_prob_array

# https://www.reddit.com/r/godot/comments/b6wn9j/creating_a_gradient_instance_in_a_script/
var colors = Globals.colors
var colors_array = Globals.colors_array

onready var treasureLabel = $TreasureLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var step = Globals.color_step
	var idx = 0.0
	var cell_size = 48
	
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
		margin_top = (int(cell[4])*cell_size)+64+2
		x.rect_position = Vector2(margin_left, margin_top)
		x.rect_size = Vector2(cell_size*.9,cell_size*.9)
		lab.rect_position = Vector2(margin_left, margin_top)
		lab.rect_size = Vector2(cell_size*.9,cell_size*.9)
		if world_prob_array.get(str(cell))['Times_Dug'] == 0.0:
			lab.text = "Not\nExplored!" + "\nActual:" +  str(world_prob_array.get(str(cell))['Prob'])
			x.color = Color(0, .5, 0, 0.25)
		else:
			lab.text = "Observed: " + str(stepify(world_prob_array.get(str(cell))['Prob_Observed'],0.01)) + "\nActual:" +  str(world_prob_array.get(str(cell))['Prob']) + "\nTimes Dug: " + str(world_prob_array.get(str(cell))['Times_Dug'])
			x.color = colors.interpolate(clamp(world_prob_array[str(cell)]['Prob_Observed'], 0.01, 0.99))
		#lab.set("theme_override_font_sizes/font_size", 8)
		#lab.add_theme_font_size_override("font_size", 8)
		lab.set("custom_fonts/font", new_font)
		lab.align = 1
		lab.valign = 1
		#lab.autowrap = true
		add_child(x)
		add_child(lab)

	treasureLabel.text += str(Globals.treasure_count) + " pieces"
