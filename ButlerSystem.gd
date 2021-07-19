extends Node2D

enum state{
	idle,
	walking,
	alert,
	wet,
}


func locate_butler(pos):
	var all_butlers = get_tree().get_nodes_in_group("butler")
	print(all_butlers)
	
	var nearest_butler = all_butlers[0]

	for butler in all_butlers:
		if butler.global_position.distance_to(pos) < nearest_butler.global_position.distance_to(pos):
			nearest_butler = butler
	if nearest_butler.global_position.distance_to(pos) < 500:
		nearest_butler.alert_location = pos
		nearest_butler.enter_state(state.alert, null)
