extends Area2D

signal purchased_item_with_id

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
