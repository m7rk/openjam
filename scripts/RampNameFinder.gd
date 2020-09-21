extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func findChild(stage, pos):
	var best_name = ""
	var best_dist = 1000000000.0
	for i in get_node(str(stage)).get_children():
		var d = pos.distance_to(i.global_position)
		if(d < best_dist):
			best_dist = d
			best_name = i.name
	return best_name
