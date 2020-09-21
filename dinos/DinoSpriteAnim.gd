extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if(int(timer) % 2 == 0):
		frame = get_node("../").getSpriteSet()
	else:
		frame = get_node("../").getSpriteSet() + 1
		
