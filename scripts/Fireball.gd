extends Node2D

var BASE_SPEED = 150
var life = 3
var speed = Vector2(0,1)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (delta * speed)
	life -= delta
	if(life <= 0):
		queue_free()
