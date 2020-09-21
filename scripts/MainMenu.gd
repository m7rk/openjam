extends MarginContainer

var t_active = false

signal player_ready

var animTime = 0

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_ENTER and visible:
		visible = false
		t_active = false
		emit_signal("player_ready")
		
func _process(delta):
	animTime += delta
	get_node("a").visible = int(animTime) % 2 == 0
	get_node("b").visible = int(animTime) % 2 == 1
