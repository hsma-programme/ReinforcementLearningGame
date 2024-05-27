extends Node

func create_probability_array(random_seed, grid_size_x, grid_size_y):
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(str(random_seed))
	
	var arr: Array
	arr.resize(grid_size_x * grid_size_y)
	arr.fill(0)
	
	var TileSetupDic = {}
	
	var p = 0.0
	
	var p_above_min_count = 0
	
	# Set up an array that will store the probabilities
	
	
	while p_above_min_count < 2:
		p_above_min_count = 0
		for x in range(grid_size_x):
			for y in range(grid_size_y):
				p = stepify(rng.randf_range(0.0, 0.8), 0.01)
				if p > 0.2:
					p_above_min_count += 1
				
				TileSetupDic [str(Vector2(x, y))] = {
					"Prob": p,
					"Times_Dug": 0.0, # float for later division
					"Times_Success": 0.0, # float for later division
					"Prob_Observed": 0.0, # float for later division
					"Prob_Estimate": rng.randf() # random float between 0 and 1
				}
		
	return TileSetupDic
	
