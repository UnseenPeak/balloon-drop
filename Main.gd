extends Node2D

export(Array, PackedScene) var targets
export(Array, PackedScene) var non_targets

var wet_list_target = preload("res://scenes/WetListTarget.tscn")
var game_manager
var count_down

func _ready():
	spawn_targets()
	spawn_non_targets()
	game_manager = get_tree().get_root().get_node("GameManager")
	count_down = get_node("GUI/CountDown")

func target_hit(npc_id):
	game_manager.inc_time()
	remove_target(npc_id)

func remove_target(npc_id):
	targets = get_tree().get_nodes_in_group("WetListTargets")
	for i in range(targets.size()):
		if targets[i].target_id == npc_id:
			targets[i].modulate.a = 0.3
			break;
	pass

func _process(_delta):
	if game_manager.seconds <= 10:
		$GUI/CountDownAnimation.play("pulse")
		count_down.modulate = Color(1,0,0)
	else:
		$GUI/CountDownAnimation.stop(false)
		count_down.modulate = Color(1,1,1)
		count_down.rect_scale = Vector2(.3,.3)
	if !game_manager.is_game_over:
		count_down.text = str(game_manager.seconds)

func spawn_non_targets():
	var non_target
	for i in 2:
		for n in non_targets.size():
			non_target = non_targets[n].instance()
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

