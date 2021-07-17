extends KinematicBody2D


enum {
	IDLE,
	TALKING,
	NEW_DIRECTION,
	MOVE,
	WET
}

var is_target = false
var speed = 50
var state = MOVE
var direction = Vector2.RIGHT
var velocity = Vector2(0,0)

var hit_1 = preload("res://sounds/hit_1.wav")
var hit_2 = preload("res://sounds/hit_2.wav")
var hit_3 = preload("res://sounds/hit_3.wav")

var all_hit_sounds = []

signal target_hit

func _ready():
	self.connect("target_hit", get_tree().get_root().get_node("Main"), "target_hit", [get_instance_id()])
	all_hit_sounds = [ hit_1, hit_2, hit_3]
	randomize()


func _process(delta):
	speed = 0
	match state:
		WET: 
			speed = 0
		TALKING:
			$AnimatedSprite.play("talking")
			
		IDLE:
			$AnimatedSprite.play("idle")
		
		NEW_DIRECTION:
			direction = choose([Vector2.LEFT, Vector2.RIGHT])
			if state == WET:
				pass
			else:
				state = choose([IDLE, MOVE])
		MOVE:
			speed = 50
#			$AnimatedSprite.play("walking")
#			velocity = move_and_slide(direction * speed, Vector2.UP)
	velocity = direction * speed
	velocity.y = 10
	velocity = move_and_slide(velocity, Vector2.UP, true)
	velocity.x = lerp(velocity.x, 0, 0.25)
	position.x = clamp(position.x, 8, 472)
	
func choose(array):
	array.shuffle()
	return array.front()
	
	
func hit_rotate():
	pass
	
func _on_Timer_timeout():
	$Timer.wait_time = choose([1, 2])
	if state != WET:
		state = choose([IDLE, NEW_DIRECTION, MOVE, TALKING])

func _on_Area2D_body_entered(body):
	if(body.name == "Balloon"):
		if is_target:
			emit_signal("target_hit")
			print(all_hit_sounds)
		$AudioStreamPlayer2D.stream = all_hit_sounds[randi() % all_hit_sounds.size()]
		$AudioStreamPlayer2D.play()
		state = WET
		$AnimatedSprite.play("hit")
		$AnimationPlayer.play("hit")
		yield($AnimatedSprite, "animation_finished" )
		queue_free()
