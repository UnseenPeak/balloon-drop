extends Control
var game_manager

signal reset_game

func _ready():
	game_manager = get_tree().get_root().get_node("GameManager")
	self.connect("reset_game", game_manager, "reset_game")

func _process(delta):
	if game_manager.is_game_over:
		visible = true


func _on_Button_pressed():
	emit_signal("reset_game")
