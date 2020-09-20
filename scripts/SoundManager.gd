extends Node2D


# Declare member variables here. Examples:
var shred = null
var main = null
var alt = null
const FADETIME = 1




var tracks = []
var selTrack = 0
var VOL_MAX = -5

var mainTargVol = VOL_MAX
var altTargVol = VOL_MAX

# Called when the node enters the scene tree for the first time.
func _ready():
	shred = get_node("shred")
	main = get_node("soundmain")
	alt = get_node("soundalt")
	
	# Load All tracks?
	tracks.append(load("res://music/o1_b.ogg"))
	tracks.append(load("res://music/o1_f.ogg"))
	tracks.append(load("res://music/o2_b.ogg"))
	tracks.append(load("res://music/o2_f.ogg"))
	tracks.append(load("res://music/o3_b.ogg"))
	tracks.append(load("res://music/o3_f.ogg"))
	shred.volume_db = -1000
	main.volume_db = VOL_MAX
	alt.volume_db = VOL_MAX

func fadeIn():
	main.stop()
	alt.stop()
	main.stream = tracks[1 + (selTrack * 2)]
	alt.stream = tracks[(selTrack * 2)]	
	mainTargVol = VOL_MAX
	main.volume_db = VOL_MAX
	altTargVol = VOL_MAX
	alt.volume_db = VOL_MAX
	main.play()
	alt.play()

	
func trackSwitch(i):
	selTrack = i - 1
	mainTargVol = -60
	altTargVol = -60
	get_node("Tween").interpolate_callback(self, 1, "fadeIn")
	get_node("Tween").start()
	

func _process(delta):
	shred.volume_db = min(VOL_MAX,-50 + (20 * get_node("../../Player").velocityShredRatio()))
	main.volume_db = lerp(main.volume_db,mainTargVol, FADETIME * delta)
	alt.volume_db = lerp(alt.volume_db,altTargVol, FADETIME * delta)


func _on_LiftSends_game_end():
	mainTargVol = -60


func _on_Map_load_level(i):
	trackSwitch(i)
