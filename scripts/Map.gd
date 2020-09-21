extends CanvasLayer

const DEFAULT_LEVEL = 1

signal load_level
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer").visible = false

func show():
	get_node("MarginContainer").visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func onLevel(i):
	get_node("MarginContainer").visible = false
	emit_signal("load_level",i)

func _on_Button1_pressed():
	onLevel(1)


func _on_Button2_pressed():
	onLevel(2)


func _on_Button3_pressed():
	onLevel(3)


func _on_Button4_pressed():
	onLevel(4)


func _on_Button5_pressed():
	onLevel(5)
	
func _on_ButtonShop_pressed():
	onLevel(0)


func _on_LiftSends_game_end():
	show()


func _on_MarginContainer_player_ready():
	emit_signal("load_level",DEFAULT_LEVEL)



