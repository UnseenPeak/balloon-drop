extends KinematicBody2D

var screen_size
var velocity = Vector2(0,0)
var balloon = preload("res://scenes/Balloon.tscn")
var has_balloon = false
const SPEED = 200
const GRAVITY = 30
var rng
var game_manager

signal balloon_released

func _ready():
	randomize()
	rng = RandomNumberGenerator.new()
	screen_size = get_viewport().size
	game_manager = get_tree().get_root().get_node("GameManager")
	
	var hose_bib = get_tree().get_root().find_node("HoseBib",true,false)
	hose_bib.connect("balloon_filled",self,"get_balloon")
	
func get_balloon():
	has_balloon = true
	$BalloonHolder.get_node("Sprite").visible = true

func _process(delta):
#	get_tree().get_root().get_node("Main").get_node("WetList").visible = false
	$Footstep.pitch_scale = rng.randf_range(0.98, 1.2) 
	if !game_manager.is_game_over:
		if Input.is_action_pressed("right"):
			velocity.x = SPEED
			if not $Footstep.is_playing():
				$Footstep.play()
		if Input.is_action_pressed("left"):
			velocity.x = -SPEED
			if not $Footstep.is_playing():
				$Footstep.play()
#		if Input.is_action_pressed("tab"):
#			get_tree().get_root().get_node("Main").get_node("WetList").visible = true
		if Input.is_action_just_pressed("drop") && has_balloon:
			$AudioStreamPlayer2D.play()
			var new_balloon = balloon.instance()
			get_tree().get_root().get_node("Main").add_child(new_balloon)
			new_balloon.position = $BalloonHolder.global_position
			$BalloonHolder.get_node("Sprite").visible = false
			has_balloon = false
			emit_signal("balloon_released")
		velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.25)
	#	How to get window with, not stretch window width?
	#	change clam value to variable instead
	position.x = clamp(position.x, 8, 820)
