extends KinematicBody2D

var thrown = false
var velocity = Vector2(0, 200)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	thrown = false


func _process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
