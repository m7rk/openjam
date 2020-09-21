extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = 0
var BPM = 120
var vframe = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setBPM(b):
	BPM = b
	timer = 0
	vframe = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if(timer > (120.0/BPM)):
		timer -= (120.0/BPM)
		vframe = (vframe + 1) % 2
		
	frame = get_node("../").getSpriteSet() + vframe
