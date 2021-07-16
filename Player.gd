extends KinematicBody2D

var screen_size
var velocity = Vector2(0,0)
const SPEED = 200
const GRAVITY = 30


func _ready():
	screen_size = get_viewport().size
	print(screen_size.x)

func _process(delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.25)

	position.x = clamp(position.x, 8, 472)
