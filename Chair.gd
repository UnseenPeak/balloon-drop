extends Area2D

var is_seat_taken


func _physics_process(delta):
	$Label.text = str(is_seat_taken)
