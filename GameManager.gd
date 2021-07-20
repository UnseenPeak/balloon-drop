extends Node

var non_targets_hit = 0
var butler_hit = false
var is_game_over = false
var display_value = 0
var time_start = 0
var time_now = 0
var time_left = 60
var main
var music_player
var elapsed
var seconds = 60

func _ready():
	main = get_tree().get_root().get_node("Main")
	music_player = main.get_node("MusicPlayer")
	time_start = OS.get_unix_time()
	set_process(true)

func _process(delta):
	if !is_game_over:
		time_now = OS.get_unix_time()
		elapsed = time_now - time_start
		seconds = 60 - elapsed
		if main.get_node("GUI/Label"):
			main.get_node("GUI/Label").text = str(seconds)
		if seconds <= 0:
			_game_over_screen()
			main.get_node("GUI/Label").text = str(0)

		if seconds <= 0:
			_game_over_screen()
			main.get_node("GUI/Label").text = str(0)
		elif seconds <= 5:
			main.get_node("MusicPlayer").pitch_scale = 1.5
		elif seconds <= 15:
			music_player.pitch_scale = 1.3
		elif seconds <= 25:
			music_player.pitch_scale = 1.1
		elif seconds > 25:
			music_player.pitch_scale = 1
		if butler_hit:
			_game_over_screen()

			
	
func _game_over_screen():
	if music_player.pitch_scale > 0.25:
		music_player.pitch_scale -= 0.005
	if music_player.pitch_scale <= 0.25:
		music_player.volume_db = -80
	is_game_over = true
	main.get_node("GUI/Label").text = ''

func inc_time():
	time_start = time_start + 5.0
	
func dec_time():
	time_start = time_start - 5.0

func reset_game():
	non_targets_hit = 0
	butler_hit = 0
	get_tree().reload_current_scene()
	main = get_tree().get_root().get_node("Main")
	is_game_over = false
