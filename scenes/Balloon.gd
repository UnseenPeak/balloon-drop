extends KinematicBody2D

var thrown = false
var velocity = Vector2(0, 200)
var game_manager
var balloon_exploded = false

func _ready():
	game_manager = get_tree().get_root().get_node("GameManager")
	thrown = false

func _process(_delta):
#	or comes in contact with NPC
	if is_on_floor():
		if !balloon_exploded:
			balloon_explode()
		balloon_exploded = true
#		velocity = Vector2(0,0)
#		$Sprite.visible = false
#		$AnimatedSprite.play("explode")
##		$Area2D/CollisionShape2D2.disabled = true
#		queue_free()
#		yield($AnimatedSprite, "animation_finished")
	velocity = move_and_slide(velocity, Vector2.UP)

func balloon_explode():
	velocity = Vector2(0,0)
	$Sprite.visible = false
	$AnimatedSprite.play("explode")
#		$Area2D/CollisionShape2D2.disabled = true
	$Splash.play()
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _on_Area2D_area_entered(area):
	if !balloon_exploded:
		balloon_explode()
	balloon_exploded = true
	if !area.get_parent().is_target:
		game_manager.non_targets_hit += 1
	if area.get_parent().is_in_group("butler"):
		game_manager.butler_hit = true	
	



func _on_Area2D_body_entered(_body):
	pass
#	$CollisionShape2D.set_deferred("disabled", true)
#	$CollisionShape2D.set_deferred("Area2D/CollisionShape2D2", true)
