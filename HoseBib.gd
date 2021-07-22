extends Area2D
var filling = false
var fill = 0
signal balloon_filled
var has_balloon = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play('drip')
	get_tree().get_root().get_node("Main").get_node("Player").connect("balloon_released",self,"no_balloon")
	pass

func _process(delta):
	if filling && fill != 100 && !has_balloon:
		if not $BalloonFilling.is_playing():
			$BalloonFilling.play()
		fill += 1
		$BalloonSprite.scale = Vector2(fill / 100.0, fill / 100.0)
		if fill >= 100:
			fill = 0
			$BalloonSprite.scale = Vector2(0,0)
			$BalloonFilling.stop()
			emit_signal("balloon_filled")
			has_balloon = true
	fill = clamp(fill, 0, 100)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func no_balloon():
	if has_balloon:
		has_balloon = false

func _on_HoseBib_body_entered(body):
	$AnimatedSprite.play('filling')
	filling = true
	


func _on_HoseBib_body_exited(body):
	
	$AnimatedSprite.play('drip')
	filling = false
	fill = 0
	$BalloonFilling.stop()
	$BalloonSprite.scale = Vector2(0,0)
	
