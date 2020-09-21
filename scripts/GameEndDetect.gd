extends Node2D

signal game_end
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var endGameFlag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func try_emit(body):
	if(body.name == "Player"):
		emit_signal("game_end")

func _on_0_hit(body, id):
	if(endGameFlag):
		# Checkpoint hit! 
		# Give player boost, next music track, and finally, clear UI
		get_node("../Camera2D/SoundManager").trackSwitch(id-1)
		get_node("../Player").refresh(id-1)
	else:
		try_emit(body)

