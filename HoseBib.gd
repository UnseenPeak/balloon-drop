extends Area2D
var filling = false
var fill = 0
signal balloon_filled

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play('drip')
	pass # Replace with function body.

func _process(delta):
#	Fill = Key E
	if filling && Input.is_action_pressed("fill"):
		if not $BalloonFilling.is_playing():
			$BalloonFilling.play()
		fill += 1
		$BalloonSprite.scale = Vector2(fill / 100.0, fill / 100.0)
		if fill >= 100:
			$BalloonSprite.scale = Vector2(0,0)
			$BalloonFilling.stop()
			emit_signal("balloon_filled")

			filling = false
	fill = clamp(fill, 0, 100)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HoseBib_body_entered(body):
	$AnimatedSprite.play('filling')
	filling = true
	$Label.visible = true
	


func _on_HoseBib_body_exited(body):
	$AnimatedSprite.play('drip')
	filling = false
	fill = 0
	$Label.visible = false
	$BalloonFilling.stop()
