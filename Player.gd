extends KinematicBody2D

var screen_size
var velocity = Vector2(0,0)
var balloon = preload("res://scenes/Balloon.tscn")
var hasBalloon = false
const SPEED = 200
const GRAVITY = 30


func _ready():
	screen_size = get_viewport().size
	print(screen_size.x)
	
	var hose_bib = get_tree().get_root().find_node("HoseBib",true,false)
	hose_bib.connect("balloon_filled",self,"get_balloon")
	
func get_balloon():
	hasBalloon = true
	$BalloonHolder.get_node("Sprite").visible = true

func _process(delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	if Input.is_action_just_pressed("drop") && hasBalloon:
		$AudioStreamPlayer2D.play()
		var new_balloon = balloon.instance()
		get_tree().get_root().get_node("Main").add_child(new_balloon)
		new_balloon.position = $BalloonHolder.global_position
		$BalloonHolder.get_node("Sprite").visible = false
		pass
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.25)
	#	How to get window with, not stretch window width?
	#	change clam value to variable instead
	position.x = clamp(position.x, 8, 472)