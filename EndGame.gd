extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0

var gold = 120
var silver = 150
var bronze = 180

var raceStarted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func secToMin(i):
	return "%01d:%02d" % [int(i/60), i % 60]

func getBestPossible():
	if time <= gold:
		return "GOLD " + secToMin(gold)
	if time <= silver:
		return "SILVER" + secToMin(silver)
	if time <= bronze:
		return "BRONZE" + secToMin(bronze)
	return " TOO SLOW..."
	
func gameOverString():
	if time <= gold:
		return "FIRST PLACE! THANKS 4 PLAYING!"
	if time <= silver:
		return "SECOND PLACE! NICE WORK!"
	if time <= bronze:
		return "THIRD PLACE! KEEP TRYING!"
	return "BETTER LUCK NEXT TIME."
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(raceStarted):
		if(get_node("EndGameLayer/Center/Label").text == ""):
			time += delta
			get_node("EndGameLayer/Time/Label").text = secToMin(int(time)) + " " + getBestPossible()
	else:
		get_node("EndGameLayer/Time/Label").text = ""
		get_node("EndGameLayer/Center/Label").text = "" 
	

func _on_Area2D_body_entered(body):
	get_node("EndGameLayer/Center/Label").text = gameOverString()
	get_node("../Player").gameEnded = true
