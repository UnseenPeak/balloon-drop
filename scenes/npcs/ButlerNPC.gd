extends KinematicBody2D

enum state{
	idle,
	walking,
	alert,
	wet,
}
var is_target = false
var is_butler = true
var speed = 60
var direction = Vector2.LEFT
var velocity = Vector2(0,0)
var alert_location

var hit_1 = preload("res://sounds/hit_1.wav")
var hit_2 = preload("res://sounds/hit_2.wav")
var hit_3 = preload("res://sounds/hit_3.wav")

var all_hit_sounds = []

signal target_hit

var npc_state = state.walking

func _ready():
	self.connect("target_hit", get_tree().get_root().get_node("Main"), "target_hit", [get_instance_id()])
	all_hit_sounds = [ hit_1, hit_2, hit_3]
	randomize()
	
	enter_state(state.walking, null)
	pass
	
func _physics_process(delta):
	$Label.text = str(speed)
	process_states()
	
func enter_state(pass_state, talking_time):
	
	if(npc_state != pass_state):
		leave_state(npc_state)
		npc_state = pass_state
		
	if(pass_state == state.walking):
		if(rand_range(0,2) > 1):
			direction = Vector2.LEFT
			get_node( "AnimatedSprite" ).set_flip_h( true )
		else:
			direction = Vector2.RIGHT
			get_node( "AnimatedSprite" ).set_flip_h( false )
		$AnimatedSprite.play("walking")
		$Timer.start(rand_range(3,6))
		
	if(pass_state == state.idle):
		$AnimatedSprite.play("idle")
		$Timer.start(2)
	
	if(pass_state == state.alert):
		$Timer.wait_time = 100
		speed = speed + 20
		$AlertSprite.visible = true
		$AnimationAlert.play("alert") 
		if alert_location.x > position.x:
			direction = Vector2.RIGHT
			get_node( "AnimatedSprite" ).set_flip_h( false )
		if alert_location.x < position.x:
			get_node( "AnimatedSprite" ).set_flip_h( true )
			direction = Vector2.LEFT
		
	if(pass_state == state.wet):
		$Timer.start(5)
		$AudioStreamPlayer2D.stream = all_hit_sounds[randi() % all_hit_sounds.size()]
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("hit")
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite, "animation_finished" )
#		queue_free()
		
func process_states():
	if(npc_state == state.walking):
		process_walking()
	if(npc_state == state.alert):
		process_alert()
	pass

func leave_state(pass_state):
#	if(pass_state == state.alert):
#		$AlertSprite.visible = false
#		$AnimationAlert.stop()
	pass
	
func process_alert():
	velocity = direction * (speed + 20);
	velocity.y = 60
	if abs(alert_location.x - position.x) < 2:
		enter_state(state.idle, null)
		$AlertSprite.visible = false
		$AnimationAlert.stop()
	velocity = move_and_slide(velocity, Vector2.UP, true)
	velocity.x = lerp(velocity.x, 0, 0.25)
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
		enter_state(state.wet, null)
#		CALL SINGELTON GAMEOVER

func _on_Timer_timeout():
#	if npc_state == state.alert:
#		$AlertSprite.visible = false
#		$AnimationAlert.stop()
	if npc_state != state.alert:
		enter_state(state.values()[randi()%2], null)
	pass

