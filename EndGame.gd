extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0

var raceStarted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func secToMin(i):
	return "%01d:%02d" % [int(i/60), i % 60]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(raceStarted):
		time += delta
		get_node("EndGameLayer/Time/Label").text = secToMin(int(time))
	else:
		get_node("EndGameLayer/Time/Label").text = ""
		get_node("EndGameLayer/Center/Label").text = "" 
	

func _on_Area2D_body_entered(body):
	# game ended.
	pass # Replace with function body.
