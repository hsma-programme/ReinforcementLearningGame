extends Node

func create_probability_array(random_seed, grid_size_x, grid_size_y):
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(str(random_seed))
	
	var arr: Array
	arr.resize(grid_size_x * grid_size_y)
	arr.fill(0)
	
	var TileSetupDic = {}
	
	# Set up an array that will store the probabilities
	for x in range(grid_size_x):
		for y in range(grid_size_y):
			TileSetupDic [str(Vector2(x, y))] = {
				"Prob": stepify(rng.randf_range(0.0, 0.8), 0.01),
				"Times_Dug": 0.0, # float for later division
				"Times_Success": 0.0, # float for later division
				"Prob_Observed": 0.0,
				"Prob_Estimate": rng.randf()
			}
		
	return TileSetupDic
	
