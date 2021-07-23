extends Node2D

export(Array, PackedScene) var targets
export(Array, PackedScene) var non_targets

var wet_list_target = preload("res://scenes/WetListTarget.tscn")
var game_manager
var count_down
var current_wetlist_target = 0
var move_wetlist = false
var targets_array = []

func _ready():
	spawn_npcs()
	game_manager = get_tree().get_root().get_node("GameManager")
	count_down = get_node("GUI/CountDown")
	if game_manager.is_intro:
		show_targets()

func target_hit(npc_id):
	game_manager.inc_time()
	remove_target(npc_id)

func remove_target(npc_id):
	targets = get_tree().get_nodes_in_group("WetListTargets")
	for i in range(targets.size()):
		if targets[i].target_id == npc_id:
			targets[i].modulate.a = 0.3
			targets[i].modulate = Color(.4,.5,1)
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
	if game_manager.is_game_over:
		count_down.text = str(0)

func spawn_npcs():
	var target
	randomize()
	targets.shuffle()
	for i in 5:
		target = targets[i].instance()
		add_child(target)
		target.is_target = true
		if(rand_range(0,2) > 1):
			target.position = Vector2(rand_range(12,276), 232)
		else:
			target.global_position = Vector2(rand_range(330,710), 205)
		
		var text_rect = wet_list_target.instance()
		text_rect.texture = target.get_node("Sprite").texture
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		text_rect.visible = false
		call_deferred("set",text_rect.rect_scale, Vector2(2,2))
		text_rect.target_id = target.get_instance_id()
		$WetList/HBoxContainer.add_child(text_rect)
		
	targets.remove(0)
	targets.remove(0)
	targets.remove(0)
	targets.remove(0)
	targets.remove(0)
	
	var non_target
	for n in targets.size():
		non_target = targets[n].instance()
		add_child(non_target)

		non_target.position = Vector2(rand_range(330,820), 205)

	for n in targets.size():
		non_target = targets[n].instance()
		add_child(non_target)

		non_target.position = Vector2(rand_range(12,276), 232)
		
	for n in targets.size():
		non_target = targets[n].instance()
		add_child(non_target)

		non_target.position = Vector2(rand_range(12,276), 232)

func show_targets():
	for i in targets.size() - 1:
		$IntroTimer.connect("timeout", self, "show_single_target")
		i = i + 1
		$IntroTimer.start(.65)
	
func show_single_target():
	if current_wetlist_target <= 4:
		$WetList/HBoxContainer.get_child(current_wetlist_target).visible = true
		current_wetlist_target += 1
		game_manager.play_hit()
	else:
		$IntroTimer.stop()
		$IntroTimer.start(2)
		move_wetlist = true
		
	if move_wetlist:
		$WetList/WetListAnimation.play("move_wetlist")
		yield($WetList/WetListAnimation, "animation_finished" )
		move_wetlist = false
		$IntroTimer.stop()
		game_manager.is_intro = false
		game_manager.play_music()
		
	
	
