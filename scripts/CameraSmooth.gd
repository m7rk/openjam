extends Camera2D

# Smoothing duration in seconds
const SMOOTHING_DURATION: = 0.1

const XFWD = 100

# Current position of the camera
var current_position: Vector2

# Position the camera is moving towards
var destination_position: Vector2

func _ready() -> void:
	current_position = position

func _process(delta: float) -> void:
	destination_position = get_node("../Player").position + Vector2(XFWD, get_node("../Player").getYVel())
	current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
	
	position = current_position.round()
	force_update_scroll()