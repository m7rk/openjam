extends Area2D

signal got_diamond

# Declare member variables here. Examples:
# var a = 2
var arg = [Vector2(0,-2),Vector2(0,2)]

func start_tween():
	
	arg.invert()
	var tween = get_node("Tween")
	var spr = get_node("Sprite")
	tween.interpolate_property(spr, "position",
		arg[0], arg[1], 1,
		Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Diamond_body_entered(body):
	emit_signal("got_diamond")
	queue_free()


func _on_Tween_tween_completed(object, key):
	start_tween()
