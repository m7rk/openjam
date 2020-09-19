extends Node2D


# Declare member variables here. Examples:
var shred = null
var main = null
var alt = null
var targVol = 0.0
const FADETIME = 0.3


# Called when the node enters the scene tree for the first time.
func _ready():
	shred = get_node("shred")
	main = get_node("soundmain")
	alt = get_node("soundalt")
	shred.volume_db = -1000

func _process(delta):
	shred.volume_db = -60 + (50 * get_node("../../Player").velocityShredRatio())
	main.volume_db = lerp(main.volume_db,targVol, FADETIME * delta)


func _on_LiftSends_game_end():
	targVol = -100
