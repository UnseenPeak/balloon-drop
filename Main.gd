extends Node2D


export(Array, PackedScene) var targets

var wet_list_target = preload("res://scenes/WetListTarget.tscn")


func _ready():
	spawn_targets()
	$MusicPlayer.play()

func target_hit(npc_id):
	remove_target(npc_id)

func remove_target(npc_id):
	var targets = get_tree().get_nodes_in_group("WetListTargets")
	for i in range(targets.size()):
		if targets[i].target_id == npc_id:
			targets[i].modulate.a = 0.3
			print('got the ID!')
			break;
	pass

func _process(delta):
	pass
	
func spawn_targets():
	var target
	for i in targets.size():
		target = targets[i].instance()
		add_child(target)
		target.is_target = true
		target.position = Vector2(100 * i, 100)
		var text_rect = wet_list_target.instance()
		text_rect.texture = target.get_node("Sprite").texture
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		text_rect.rect_scale = Vector2(2,2)
		text_rect.target_id = target.get_instance_id()
		$WetList/TextureRect/HBoxContainer.add_child(text_rect)
#		get_instance_id 
