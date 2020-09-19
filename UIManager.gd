extends CanvasLayer

var airTimeTotal = 0
var inAir = false

var pointsThisRun = 0
var pointsTotal = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(inAir):
		airTimeTotal += delta


func _on_Player_airborne(air):
	inAir = air
	if(!air):
		pointsThisRun += airTimeTotal
		
