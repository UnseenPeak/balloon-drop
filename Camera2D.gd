extends Camera2D

var follow = false
var default_position = position
var target
var game_manager


func _ready():
	var player = get_tree().get_root().find_node("Player",true,false)
	player.connect("balloon_released",self,"follow_balloon")
	game_manager = get_tree().get_root().get_node("GameManager")

func _process(delta):
	if !game_manager.is_game_won:	
		if follow:
			if get_tree().get_root().get_node("Main").get_node("Balloon"):
				smoothing_enabled = false
				set_global_position(lerp(get_global_position(), target.get_global_position(), delta*5))
				if zoom.x > .6:
					zoom += Vector2(-.005, -.005)
			else:
				smoothing_enabled = true
				var player_pos = get_tree().get_root().get_node("Main/Player").get_global_position()
				set_global_position(lerp(get_global_position(), (Vector2(player_pos.x,135)), delta*5))
				if zoom.x <= 1:
					zoom += Vector2(.01, .01)
		else:
			follow = false
	else:
#		smoothing_enabled = false
		var player_pos = get_tree().get_root().get_node("Main/Player").get_global_position()
		set_global_position(lerp(get_global_position(), Vector2(player_pos.x, 15), delta))
		if zoom.x > .4:
			zoom += Vector2(-.002, -.002)
func follow_balloon():
	follow = true
	target = get_tree().get_root().get_node("Main").get_node("Balloon")
