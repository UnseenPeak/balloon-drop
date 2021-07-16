extends KinematicBody2D


enum {
	IDLE,
	TALKING,
	NEW_DIRECTION,
	MOVE
}

const SPEED = 50
var state = MOVE
var direction = Vector2.RIGHT

func _ready():
	randomize()


func _process(delta):
	match state:
		TALKING:
			$AnimatedSprite.play("talking")
			
		IDLE:
			$AnimatedSprite.play("idle")
		
		NEW_DIRECTION:
			direction = choose([Vector2.RIGHT, Vector2.LEFT])
			state = choose([IDLE, MOVE])
			
		MOVE:
			$AnimatedSprite.play("walking")
			move(delta)
	position.x = clamp(position.x, 8, 472)
func move(delta):
	position += direction * SPEED * delta
	
func choose(array):
	array.shuffle()
	return array.front()
	
func _on_Timer_timeout():
	$Timer.wait_time = choose([0.25, 0.5, 1])
	state = choose([IDLE, NEW_DIRECTION, MOVE, TALKING])

			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
