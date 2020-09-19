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
	var player = get_node("../Player")
	if(inAir):
		airTimeTotal += delta
		get_node("right/right/AirTime").text = "AIRTIME: " + ("%1.1f" % airTimeTotal)
	
	get_node("left/left/Stamina").value = player.getStaminaPct()
	get_node("left/left/Speed").text = str(int(player.fwdVelocity/15)) + " MPH"


func _on_Player_airborne(air):
	inAir = air
	if(!air):
		pointsThisRun += airTimeTotal
		airTimeTotal = 0
		
