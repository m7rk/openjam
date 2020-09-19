extends Node2D

signal game_end
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func try_emit(body):
	if(body.name == "Player"):
		emit_signal("game_end")

func _on_GameEnd_body_entered(body):
	try_emit(body)
