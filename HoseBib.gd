extends Area2D
var filling = false
var fill = 0
signal balloon_filled

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
#	Fill = Key E
	if filling && Input.is_action_pressed("fill"):
		fill += 1
		$ProgressBar.value = fill
		if fill >= 100:
			emit_signal("balloon_filled")
#			send signal to player to have balloon

			filling = false
	fill = clamp(fill, 0, 100)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HoseBib_body_entered(body):
	filling = true
	$Label.visible = true
	


func _on_HoseBib_body_exited(body):
	filling = false
	fill = 0
	$ProgressBar.value = fill
	$Label.visible = false
