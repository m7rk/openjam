extends CanvasLayer



var airTimeTotal = 0
var inAir = false

var pointsTotal = 0
var pointsCurrent = 0
var fadeTime = 3

const POINTANIMTIME = 8
const POINTPOWER = 2.0

var overRideText = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("../Player")
	if(inAir):
		fadeTime = 3
		airTimeTotal += delta
		get_node("right/right/AirTime").text = "AIRTIME: " + ("%1.1f" % airTimeTotal)
		get_node("right/right/AirTime").add_color_override("font_color", Color(1-(airTimeTotal/10),1,1-(airTimeTotal/10),1))
	else:
		if(overRideText != ""):
			get_node("right/right/AirTime").text = overRideText
			get_node("right/right/AirTime").add_color_override("font_color", Color(1,0,0,max(0,fadeTime)))
		else:	
			get_node("right/right/AirTime").add_color_override("font_color", Color(1,1,1,max(0,fadeTime)))
		fadeTime -= delta
	
	get_node("left/left/Stamina").value = player.getStaminaPct()
	get_node("left/left/Speed").text = " " + str(int(player.fwdVelocity/15)) + " MPH"
	
	var points = get_node("right/right/Points")
	pointsCurrent = lerp(pointsCurrent,pointsTotal,POINTANIMTIME * delta)
	if(pointsTotal - 1 == int(pointsCurrent)):
		pointsCurrent = pointsTotal
	points.text = str(int(pointsCurrent)) + " PTS"


func _on_Player_airborne(air):
	inAir = air
	if(air):
		overRideText = ""
	if(!air):
		pointsTotal += int(10 * pow(airTimeTotal,POINTPOWER))
		airTimeTotal = 0
		

func _on_Diamond_got_diamond():
	pointsTotal += 25
	get_node("diamond").play()

func wipeout():
	airTimeTotal = 0
	pointsTotal = max(0, pointsTotal - 20)
	overRideText = "WIPEOUT! -20 PTS!"
