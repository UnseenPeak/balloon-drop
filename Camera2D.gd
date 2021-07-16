extends Camera2D

var follow = false
var default_position = position
var target


func _ready():
	var player = get_tree().get_root().find_node("Player",true,false)
	player.connect("balloon_released",self,"follow_balloon")

func _process(delta):
	if follow:
		if get_tree().get_root().get_node("Main").get_node("Balloon"):
			set_global_position(lerp(get_global_position(), target.get_global_position(), delta*5))
			if zoom.x > .6:
				zoom += Vector2(-.005, -.005)
		else:
			set_global_position(lerp(get_global_position(), default_position, delta*5))
			if zoom.x <= 1:
				zoom += Vector2(.01, .01)
	else:
		follow = false

func follow_balloon():
	follow = true
	target = get_tree().get_root().get_node("Main").get_node("Balloon")
