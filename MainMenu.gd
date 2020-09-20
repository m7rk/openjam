extends MarginContainer

var t_active = false

signal player_ready

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_ENTER:
		visible = false
		t_active = false
		emit_signal("player_ready")
