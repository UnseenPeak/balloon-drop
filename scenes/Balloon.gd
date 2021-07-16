extends KinematicBody2D

var thrown = false
var velocity = Vector2(0, 200)

func _ready():
	thrown = false

func _process(delta):
#	or comes in contact with NPC
	if is_on_floor():
		velocity = Vector2(0,0)
		$Sprite.visible = false
		$AnimatedSprite.play("explode")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

