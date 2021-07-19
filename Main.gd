extends Node2D

export(Array, PackedScene) var targets
export(Array, PackedScene) var non_targets

var wet_list_target = preload("res://scenes/WetListTarget.tscn")

func _ready():
	spawn_targets()
	spawn_non_targets()
	$MusicPlayer.play()

func target_hit(npc_id):
	remove_target(npc_id)

func remove_target(npc_id):
	var targets = get_tree().get_nodes_in_group("WetListTargets")
	for i in range(targets.size()):
		if targets[i].target_id == npc_id:
			targets[i].modulate.a = 0.3
			break;
	pass

func _process(delta):
	pass
	
func spawn_non_targets():
	var non_target
	for i in 16:
		non_target = non_targets[0].instance()
		add_child(non_target)
		
		if(rand_range(0,2) > 1):
			non_target.position = Vector2(rand_range(12,276), 238)
		else:
			non_target.position = Vector2(rand_range(330,820), 205)


func spawn_targets():
	var target
	for i in targets.size():
		target = targets[i].instance()
		add_child(target)
		target.is_target = true
		
		if(rand_range(0,2) > 1):
			target.position = Vector2(rand_range(12,276), 238)
		else:
			target.global_position = Vector2(rand_range(330,820), 205)

		var text_rect = wet_list_target.instance()
		text_rect.texture = target.get_node("Sprite").texture
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		call_deferred("set",text_rect.rect_scale, Vector2(2,2))
		text_rect.target_id = target.get_instance_id()
		$WetList/TextureRect/HBoxContainer.add_child(text_rect)


func _on_Timer_timeout():
	pass # Replace with function body.
