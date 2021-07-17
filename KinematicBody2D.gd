extends KinematicBody2D


enum {
	IDLE,
	TALKING,
	NEW_DIRECTION,
	MOVE
}

var is_target = false
var speed = 50
var state = MOVE
var direction = Vector2.RIGHT
var velocity = Vector2(0,0)

signal target_hit

func _ready():
	self.connect("target_hit", get_tree().get_root().get_node("Main"), "target_hit", [get_instance_id()])
	randomize()


func _process(delta):
	if is_target:
		get_node("AnimatedSprite").modulate = Color(0,1,0)
	speed = 0
	match state:
		TALKING:
			$AnimatedSprite.play("talking")
			
		IDLE:
			$AnimatedSprite.play("idle")
		
		NEW_DIRECTION:
			direction = choose([Vector2.LEFT, Vector2.RIGHT])
			state = choose([IDLE, MOVE])
			
		MOVE:
			speed = 50
			$AnimatedSprite.play("walking")
#			velocity = move_and_slide(direction * speed, Vector2.UP)
	velocity = direction * speed
	velocity.y = 10
	velocity = move_and_slide(velocity, Vector2.UP, true)
	velocity.x = lerp(velocity.x, 0, 0.25)
	position.x = clamp(position.x, 8, 472)
	
func choose(array):
	array.shuffle()
	return array.front()
	
func _on_Timer_timeout():
	$Timer.wait_time = choose([1, 2])
	state = choose([IDLE, NEW_DIRECTION, MOVE, TALKING])

			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if(body.name == "Balloon" && is_target):
		emit_signal("target_hit")
