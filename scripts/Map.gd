extends CanvasLayer

const DEFAULT_LEVEL = 1

var currLevel = 0

signal load_level
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var liftTickets = 12


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer").visible = false

func ticketsReq(i):
	return 1 + int(abs((currLevel - 1) - i)/2)
	
func prepareButton(v, i):
	var tr = ticketsReq(i)
	v.get_node("Label").text = "NEED\n" + str(tr) + (" TICKET" if tr == 1 else " TICKETS")
	if(liftTickets == 0):
		v.get_node("Label").text = "CLOSED"
	
	if(i == 5):
		if(liftTickets > 0):
			v.get_node("Label").text = "USE ALL TICKETS\n TO PREPARE."
		else:
			v.get_node("Label").text = "THE TIME HAS COME."
	
func show():
	get_node("MarginContainer").visible = true
	prepareButton(get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Button1"),1)
	prepareButton(get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Button2"),2)
	prepareButton(get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Button3"),3)
	prepareButton(get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Button4"),4)
	prepareButton(get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Button5"),5)
	prepareButton(get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureRect/ButtonShop"),0)
	
	get_node("MarginContainer/VBoxContainer/TicketsLeft").text = str(liftTickets) + (" TICKET" if liftTickets == 1 else " TICKETS")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func onLevel(i):
	get_node("MarginContainer").visible = false
	emit_signal("load_level",i)
	currLevel = i
	if(i == 5):
		get_node("../LiftSends").endGameFlag = true
		get_node("../EndGame").raceStarted = true
		get_node("../Helpers").visible = false

func _on_Button1_pressed():
	
	if(liftTickets >= ticketsReq(1)):
		liftTickets -= ticketsReq(1)
		onLevel(1)

func _on_Button2_pressed():
	
	if(liftTickets >= ticketsReq(2)):
		liftTickets -= ticketsReq(2)
		onLevel(2)

func _on_Button3_pressed():
	
	if(liftTickets >= ticketsReq(3)):
		liftTickets -= ticketsReq(3)
		onLevel(3)


func _on_Button4_pressed():
	
	if(liftTickets >= ticketsReq(4)):
		liftTickets -= ticketsReq(4)
		onLevel(4)

func _on_Button5_pressed():
	if(liftTickets == 0):
		onLevel(5)
	
func _on_ButtonShop_pressed():
	
	if(liftTickets >= ticketsReq(0)):
		liftTickets -= ticketsReq(0)
		onLevel(0)


func _on_LiftSends_game_end():
	show()


func _on_MarginContainer_player_ready():
	currLevel = DEFAULT_LEVEL
	emit_signal("load_level",DEFAULT_LEVEL)



