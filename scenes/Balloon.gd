extends KinematicBody2D

var thrown = false
var velocity = Vector2(0, 200)
var game_manager

func _ready():
	game_manager = get_tree().get_root().get_node("GameManager")
	thrown = false

func _process(delta):
#	or comes in contact with NPC
	if is_on_floor():
		balloon_explode()
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

	print('area enter!')
#	$CollisionShape2D.set_deferred("Area2D/CollisionShape2D2", true)
	yield($AnimatedSprite, "animation_finished")
	queue_free()
	print($CollisionShape2D.disabled)

func _on_Area2D_area_entered(area):
	balloon_explode()
	if !area.get_parent().is_target:
		game_manager.non_targets_hit += 1
	if area.get_parent().is_in_group("butler"):
		game_manager.butler_hit = true	
	



func _on_Area2D_body_entered(body):
	pass
#	$CollisionShape2D.set_deferred("disabled", true)
#	$CollisionShape2D.set_deferred("Area2D/CollisionShape2D2", true)
