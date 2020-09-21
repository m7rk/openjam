extends Area2D

export(int) var cost
export(int) var id
# Declare member variables here. Examples:
# var a = 2
var arg = [Vector2(0,-2),Vector2(0,2)]

func start_tween():
	
	arg.invert()
	var tween = get_node("Tween")
	var spr = get_node("Sprite")
	tween.interpolate_property(spr, "position",
		arg[0], arg[1], 0.5,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	get_node("Label").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tween_tween_completed(object, key):
	start_tween()


func _on_Area2D_body_entered(body):
	get_node("Label").visible = true


func _on_Area2D_body_exited(body):
	get_node("Label").visible = false
	
func activateItem():
	get_node("../BuySound").play()
	# This is shit but i am running out of time
	var p = get_node("../../Player")
	# no switch statement
	if id == 0:
		p.boardLevel = 1
	if id == 1:
		p.boardLevel = 2
	if id == 2:
		p.boardLevel = 3
	if id == 3:
		p.hasScarf = true
	if id == 4:
		p.hasFireball = true
	if id == 5:
		p.hasEnergyDrink = true
	if id == 6:
		p.hasJetpack = true
	

func _input(ev):
	if(get_node("Label").visible):
		if Input.is_key_pressed(KEY_DOWN) && get_node("../../UI").pointsTotal >= cost:
			get_node("../../UI").pointsTotal -= cost
			activateItem()
			queue_free()
