extends Node

var non_targets_hit = 0
var butler_hit = false
var is_game_over = false
var is_game_won = false
var is_intro = true
var display_value = 0
var time_start = 0
var time_now = 0
var time_left = 45
var elapsed
var seconds = 50
var toast_height = 0
var target_count = 0

func load_game():
	get_tree().change_scene("res://Main.tscn")
	time_start = OS.get_unix_time()

func _ready():
	set_process(true)

func _process(_delta):
	if !is_intro && !is_game_won:
		time_now = OS.get_unix_time()
		elapsed = time_now - time_start
		if !is_game_over:
			seconds = 55 - elapsed
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
			
		if target_count >= 5:
			game_won_screen()
	elif is_game_won && !is_game_over:
		if $MusicPlayer.volume_db > -80.0:
			$MusicPlayer.volume_db -= 0.25
		if $MusicPlayerWon.volume_db <= 0.0:
			$MusicPlayerWon.volume_db += 0.25
		
func game_won_screen():
	$MusicPlayerWon.play()
	is_game_won = true
	
func _game_over_screen():
	if $MusicPlayer.pitch_scale > 0.25:
		$MusicPlayer.pitch_scale -= 0.003
	if $MusicPlayer.pitch_scale <= 0.25:
		$MusicPlayer.volume_db = -80
	is_game_over = true
	Engine.time_scale = 0.2

func inc_time():
#	time_start = time_start + 5.0
	target_count += 1
#	toast_stagger()
	
func dec_time():
	time_start = time_start - 5.0
	toast_stagger()

func toast_stagger():
#	if toast_height >= 30:
#		toast_height = 0
	toast_height = toast_height + 30
	
func play_music():
		$MusicPlayer.play()
func play_hit():
	$Hit.play()
func reset_game():
	non_targets_hit = 0
	butler_hit = 0
	get_tree().reload_current_scene()
	is_game_over = false
	seconds = 50
	time_now = OS.get_unix_time()
	time_start = OS.get_unix_time()
	Engine.time_scale = 1
	$MusicPlayer.volume_db = 0
	$MusicPlayer.pitch_scale = 1
	is_intro = true
	is_game_won = false
	target_count = 0
	$MusicPlayerWon.stop()
	$MusicPlayer.stop()
