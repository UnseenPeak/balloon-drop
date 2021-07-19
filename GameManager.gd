extends Node

var non_targets_hit = 0
var butler_hit = false
var is_game_over = false

func _ready():
	print('game ready!')

func _process(delta):
	if butler_hit:
		_game_over_screen()
	
func _game_over_screen():
	is_game_over = true


func reset_game():
	is_game_over = false
	non_targets_hit = 0
	butler_hit = 0
	get_tree().reload_current_scene()
