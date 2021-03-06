extends KinematicBody2D

enum state{
	idle,
	walking,
	wet,
	sitting,
	talking,
	receive_talking
}

var is_talking = false
var is_sitting = false
var is_target = false
var hit_played = false
var speed = 50
var direction = Vector2.LEFT
var velocity = Vector2(0,0)
var current_seat
var current_talking_to

var hit_1 = preload("res://sounds/hit_1.wav")
var hit_2 = preload("res://sounds/hit_2.wav")
var hit_3 = preload("res://sounds/hit_3.wav")

var all_hit_sounds = []

signal target_hit
signal initiate_talking
signal locate_closets_butler

var npc_state = state.idle
var game_manager


func _ready():
	speed = rand_range(40,60)
	self.connect("target_hit", get_tree().get_root().get_node("Main"), "target_hit", [get_instance_id()])
	all_hit_sounds = [ hit_1, hit_2, hit_3]
	game_manager = get_tree().get_root().get_node("GameManager")
	randomize()
	pass
	
func _physics_process(_delta):
#	$Label.text = str(npc_state)
#	$Label2.text = str(is_talking)
	process_states()
	
func enter_state(pass_state, talking_time):
	if !game_manager.is_intro:
		if(npc_state != pass_state):
			leave_state(npc_state)
			npc_state = pass_state
			
		if(pass_state == state.walking):
			if(rand_range(0,2) > 1):
				direction = Vector2.LEFT
				$AnimatedSprite.flip_h = true
			else:
				direction = Vector2.RIGHT
				$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("walking")
			$Timer.start(rand_range(2,5))
			
		if(pass_state == state.idle):
			$AnimatedSprite.play("idle")
			
		if(pass_state == state.wet):
			$Timer.start(5)
			$AudioStreamPlayer2D.stream = all_hit_sounds[randi() % all_hit_sounds.size()]
			$AudioStreamPlayer2D.play()
			if is_target:		
				$HitTimer.start(.3)
				$Time/ShowTime.text = str("")
				$Time/ShowTimeText.text = str("CORRECT TARGET")
				$Time/ShowTime.modulate = Color(.2,.9,.2)
				$Time/ShowTimeText.modulate = Color(.2,.9,.2)
			else:
				$Time/ShowTime.modulate = Color(.9,.2,.2)
				$Time/ShowTimeText.modulate = Color(.9,.2,.2)
			$Time/ShowTime.visible = true
			$Time/ShowTimeText.visible = true
			$AnimationPlayer.play("hit")
			$AnimatedSprite.play("hit")
			$ShowTimeAnimation.play("fade")
			yield($AnimatedSprite, "animation_finished" )
			$Time/ShowTime.visible = false
			queue_free()
			
		if(pass_state == state.sitting):
			is_sitting = true
			$AnimatedSprite.play("sitting")
			$Timer.start(rand_range(2,5))
			
		if(pass_state == state.talking):
			$AnimatedSprite.play("talking")
			is_talking = true
			if talking_time:
				$Timer.start(talking_time)
			else:
				talking_time = rand_range(2,5)
				$Timer.start(talking_time)
			
			self.connect("initiate_talking", get_tree().get_root().get_node("Main").get_node(current_talking_to.name), "initiate_talking", [talking_time])
			emit_signal("initiate_talking")
			
		if(pass_state == state.receive_talking):
			$AnimatedSprite.play("talking")
			is_talking = true
			if talking_time:
				$Timer.start(talking_time)
			else:
				talking_time = rand_range(2,5)
				$Timer.start(talking_time)		
			
func process_states():
	if(npc_state == state.walking):
		process_walking()
	pass

func leave_state(pass_state):
	pass
	
func process_walking():
	velocity = direction * speed;
	velocity.y = 30
	velocity = move_and_slide(velocity, Vector2.UP, true)
	velocity.x = lerp(velocity.x, 0, 0.25)
	if(is_on_wall()):
		if direction == Vector2.LEFT:
			get_node( "AnimatedSprite" ).set_flip_h( false )
			direction = Vector2.RIGHT
		else:
			get_node( "AnimatedSprite" ).set_flip_h( true )
			direction = Vector2.LEFT
	pass
	
func initiate_talking(time):
	enter_state(state.receive_talking, time)
	
	

func _on_Area2D_body_entered(body):
	if(body.name == "Balloon"):
		if is_target:
			emit_signal("target_hit")
#			get_tree().get_root().get_node("Main").get_node("Hit").play()
		else:
			game_manager.dec_time()
		self.connect("locate_closets_butler", get_tree().get_root().get_node("Main").get_node("ButlerSystem"), "locate_butler", [global_position])
		emit_signal("locate_closets_butler")
		enter_state(state.wet, null)
	if(body.is_in_group("npc")):
		if(!body.is_talking && !body.is_sitting):
			if(rand_range(0,50) > 49):
				current_talking_to = body
				enter_state(state.talking, null)
		
func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	if(area.is_in_group("seat")):
		if(!area.is_seat_taken):
			#	change to sit
			if(rand_range(0,10) > 9):
				current_seat = area
				area.is_seat_taken = true 
				enter_state(state.sitting, null)


func _on_Timer_timeout():
#	enter state with random item from first two enums
	if npc_state == state.sitting:
		current_seat.is_seat_taken = false
		current_seat = false
		is_sitting = false
	if npc_state == state.talking || npc_state == state.receive_talking:
#		current_talking_to.is_talking = false
		is_talking = false
		
	enter_state(state.values()[randi()%2], null)
	pass



func _on_HitTimer_timeout():
	if !hit_played:
		$Hit.play()
		hit_played = true
