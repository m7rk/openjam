extends Node2D

# Declare member variables here. Examples:
# var a = 2
var arg = [Vector2(0,0),Vector2(0,-35)]

func start_tween():
	
	arg.invert()
	var tween = get_node("Tween")
	var spr = get_node("AnimatedSprite")
	tween.interpolate_property(spr, "position",
		arg[0], arg[1], 0.7,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()

func _on_Tween_tween_completed(object, key):
	start_tween()


func _on_Area2D_body_entered(body):
	get_node("../../UI").hitBat()

func _on_Area2D_area_entered(area):
	if(area.get_node("../").name == "Player"):
		return
	queue_free()
	area.get_node("../").queue_free()
