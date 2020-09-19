extends CPUParticles2D

const SNOW_SCALE_TIME = 2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var targ_scale_amount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setIntensity(f):
	targ_scale_amount = 2 * f

func setOffset(d):
 position = Vector2(5,10 + d)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale_amount = lerp(scale_amount, targ_scale_amount,SNOW_SCALE_TIME * delta)
