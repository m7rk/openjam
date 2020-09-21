extends Node2D


# Declare member variables here. Examples:
var shred = null
var main = null
var alt = null
const FADETIME = 1
const SHRED_MAX = -15



var tracks = []
var BPM = []
var selTrack = 0
var VOL_MAX = -8

var mainTargVol = VOL_MAX
var altTargVol = VOL_MAX

# Called when the node enters the scene tree for the first time.
func _ready():
	shred = get_node("shred")
	main = get_node("soundmain")
	alt = get_node("soundalt")
	
	# Load All tracks?
	tracks.append(load("res://music/00.ogg"))
	tracks.append(null)
	tracks.append(load("res://music/01_b.ogg"))
	tracks.append(load("res://music/01_f.ogg"))
	tracks.append(load("res://music/02_b.ogg"))
	tracks.append(load("res://music/02_f.ogg"))
	tracks.append(load("res://music/03_b.ogg"))
	tracks.append(load("res://music/03_f.ogg"))
	tracks.append(load("res://music/04_b.ogg"))
	tracks.append(load("res://music/04_f.ogg"))
	tracks.append(load("res://music/05_b.ogg"))
	tracks.append(load("res://music/05_f.ogg"))
	
	BPM.append(110)
	BPM.append(120)
	BPM.append(186)
	BPM.append(100)
	BPM.append(130)
	BPM.append(110)
	
	
	shred.volume_db = -1000
	shred.play()
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
	get_node("../../Player/Sprite").setBPM(BPM[selTrack])

	
func trackSwitch(i):
	selTrack = i
	mainTargVol = -60
	altTargVol = -60
	get_node("Tween").interpolate_callback(self, 1, "fadeIn")
	get_node("Tween").start()
	

func _process(delta):
	shred.volume_db = min(SHRED_MAX ,-70 + (40 * get_node("../../Player").velocityShredRatio()))
	main.volume_db = lerp(main.volume_db,mainTargVol, FADETIME * delta)
	alt.volume_db = lerp(alt.volume_db,altTargVol, FADETIME * delta)


func _on_LiftSends_game_end():
	mainTargVol = -60


func _on_Map_load_level(i):
	trackSwitch(i)


func _on_Player_landed():
	get_node("land").play()
