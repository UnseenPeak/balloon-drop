extends Node2D

signal load_game


func _ready():
	$CanvasLayer/AnimationPlayer.play("menu")
	connect("load_game",get_tree().get_root().get_node("GameManager"),"load_game")
	


func _on_Button_pressed():
	emit_signal("load_game")
