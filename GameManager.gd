extends Node

var non_targets_hit = 0
var butler_hit = false
var is_game_over = false
var display_value = 0
var time_start = 0
var time_now = 0
var time_left = 60
var elapsed
var seconds = 60

func _ready():
	time_start = OS.get_unix_time()
	set_process(true)
	$MusicPlayer.play()

func _process(_delta):
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	if !is_game_over:
		seconds = 12 - elapsed
	if seconds <= 0 || is_game_over:
		_game_over_screen()
	elif seconds <= 10:
		if $MusicPlayer.pitch_scale > 1.1 && $MusicPlayer.pitch_scale < 1.3:
			$MusicPlayer.pitch_scale += 0.001
		
	elif seconds <= 15:
		if $MusicPlayer.pitch_scale < 1.1:
			$MusicPlayer.pitch_scale += 0.001

	if butler_hit:
		_game_over_screen()
	
func _game_over_screen():
	if $MusicPlayer.pitch_scale > 0.25:
		$MusicPlayer.pitch_scale -= 0.003
	if $MusicPlayer.pitch_scale <= 0.25:
		$MusicPlayer.volume_db = -80
	is_game_over = true
	Engine.time_scale = 0.2

func inc_time():
	time_start = time_start + 5.0
	
func dec_time():
	time_start = time_start - 5.0

func reset_game():
	non_targets_hit = 0
	butler_hit = 0
	get_tree().reload_current_scene()
	is_game_over = false
	seconds = 60
	time_now = OS.get_unix_time()
	time_start = OS.get_unix_time()
	Engine.time_scale = 1
	$MusicPlayer.volume_db = 0
	$MusicPlayer.pitch_scale = 1
	$MusicPlayer.play()
